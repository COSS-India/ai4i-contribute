import 'dart:io';
import 'package:VoiceGive/common_widgets/audio_player/widgets/audio_player_skeleton.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomAudioPlayer extends StatefulWidget {
  final String filePath;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? sliderHeight;
  final VoidCallback? onAudioEnded;
  final bool showReplayButton;

  const CustomAudioPlayer({
    super.key,
    required this.filePath,
    this.activeColor,
    this.inactiveColor,
    this.sliderHeight,
    this.onAudioEnded,
    this.showReplayButton = true,
  });

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isSeeking = false;
  bool _isLoading = true;
  bool _hasEnded = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _player = AudioPlayer();

    try {
      debugPrint('Initializing audio player with file: ${widget.filePath}');

      // Handle different file path types (blob URLs for web, file paths for mobile)
      if (kIsWeb || widget.filePath.startsWith('blob:')) {
        // For web blob URLs
        await _player.setUrl(widget.filePath);
      } else {
        // For mobile file paths - verify file exists first
        final file = File(widget.filePath);
        if (await file.exists()) {
          final fileSize = await file.length();
          debugPrint('Audio file exists, size: $fileSize bytes');
          if (fileSize == 0) {
            throw Exception('Audio file is empty');
          }
          await _player.setFilePath(widget.filePath);
        } else {
          throw Exception('Audio file does not exist: ${widget.filePath}');
        }
      }

      // Wait a bit for the file to be fully loaded
      await Future.delayed(const Duration(milliseconds: 100));

      // Get duration after file is loaded
      final duration = _player.duration;
      debugPrint('Audio duration: $duration');

      setState(() {
        _duration = duration ?? Duration.zero;
        _isLoading = false;
      });

      // Listen to position changes
      _player.positionStream.listen((pos) {
        if (!_isSeeking && mounted) {
          setState(() => _position = pos);
        }
      });

      // Listen to duration changes
      _player.durationStream.listen((dur) {
        if (mounted) {
          debugPrint('Duration updated: $dur');
          setState(() => _duration = dur ?? Duration.zero);
        }
      });

      // Listen to player state changes
      _player.playerStateStream.listen((state) {
        if (mounted) {
          debugPrint(
              'Player state: ${state.processingState}, playing: ${state.playing}');
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              _isPlaying = false;
              _position = _duration;
              _hasEnded = true;
            });

            // Trigger callback when audio ends
            if (widget.onAudioEnded != null) {
              widget.onAudioEnded!();
            }
          } else {
            setState(() {
              _isPlaying = state.playing;
              // Reset hasEnded flag when playing starts
              if (state.playing) {
                _hasEnded = false;
              }
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(CustomAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      // If the file path changes, reinitialize the player
      _initilizeFlags();
    }
  }

  Future<void> _initilizeFlags() async {
    await _player.dispose();
    _isLoading = true;
    _position = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _hasEnded = false;
    _initializePlayer();
  }
  
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  Future<void> _handlePlayPause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        // If at end, seek to start before playing
        if (_position >= _duration && _duration > Duration.zero) {
          await _player.seek(Duration.zero);
          setState(() {
            _position = Duration.zero;
            _hasEnded = false;
          });
        }
        await _player.play();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
    }
  }

  Future<void> _handleReplay() async {
    try {
      await _player.seek(Duration.zero);
      setState(() {
        _position = Duration.zero;
        _hasEnded = false;
      });
      await _player.play();
    } catch (e) {
      debugPrint('Error in replay: $e');
    }
  }

  Future<void> _seekTo(Duration position) async {
    try {
      await _player.seek(position);
      // Reset hasEnded flag when seeking
      if (_hasEnded && position < _duration) {
        setState(() => _hasEnded = false);
      }
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  Widget _buildPlayButton() {
    if (_hasEnded && widget.showReplayButton) {
      // Show replay button when audio has ended
      return IconButton(
        icon: Icon(
          Icons.replay_circle_filled_outlined,
          size: 40,
          color: widget.activeColor ?? Theme.of(context).primaryColor,
        ),
        onPressed: _handleReplay,
        tooltip: 'Replay',
      );
    } else {
      // Show normal play/pause button
      return IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          size: 40,
          color: widget.activeColor ?? Theme.of(context).primaryColor,
        ),
        onPressed: _handlePlayPause,
        tooltip: _isPlaying ? 'Pause' : 'Play',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sliderColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final sliderBgColor = widget.inactiveColor ?? Colors.grey.shade300;
    final sliderH = widget.sliderHeight ?? 2.5;

    // Ensure slider values are valid
    final sliderMax = _duration.inMilliseconds.toDouble() > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final sliderValue = _position.inMilliseconds.clamp(0.0, sliderMax);

    if (_isLoading) {
      return const Center(
        child: AudioPlayerSkeleton(),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40).r,
          border: Border.all(color: AppColors.darkGreen),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayButton(),
          const SizedBox(width: 8),
          Text(
            _formatTime(_position),
            style: TextStyle(
              fontSize: 12,
              color: _hasEnded
                  ? sliderColor.withValues(alpha: 0.7)
                  : Colors.black87,
              fontWeight: _hasEnded ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: sliderH,
                  activeTrackColor: sliderColor,
                  inactiveTrackColor: sliderBgColor,
                  thumbColor: sliderColor,
                  overlayColor: sliderColor.withValues(alpha: 0.2),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  min: 0.0,
                  max: sliderMax,
                  value: sliderValue.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _isSeeking = true;
                      _position = Duration(milliseconds: value.toInt());
                    });
                  },
                  onChangeEnd: (value) async {
                    await _seekTo(Duration(milliseconds: value.toInt()));
                    setState(() => _isSeeking = false);
                  },
                ),
              ),
            ),
          ),
          Text(
            _formatTime(_duration),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          // Optional: Add a small indicator when audio has ended
          if (_hasEnded && widget.showReplayButton)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: sliderColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Ended',
                style: TextStyle(
                  fontSize: 10,
                  color: sliderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
