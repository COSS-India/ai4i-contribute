import 'dart:io';
import 'package:VoiceGive/common_widgets/audio_player/widgets/audio_player_skeleton.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/providers/audio_playback_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SunoAudioPlayer extends StatefulWidget {
  final String filePath;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? sliderHeight;
  final VoidCallback? onAudioEnded;
  final VoidCallback? onAudioStarted;
  final bool showReplayButton;
  final bool separatePlayButton;

  const SunoAudioPlayer({
    super.key,
    required this.filePath,
    this.activeColor,
    this.inactiveColor,
    this.sliderHeight,
    this.onAudioEnded,
    this.onAudioStarted,
    this.showReplayButton = true,
    this.separatePlayButton = false,
  });

  @override
  State<SunoAudioPlayer> createState() => SunoAudioPlayerState();
}

class SunoAudioPlayerController {
  SunoAudioPlayerState? _state;

  void _attach(SunoAudioPlayerState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  Widget get playButton => _state?._buildPlayButton() ?? SizedBox.shrink();
}

class SunoAudioPlayerState extends State<SunoAudioPlayer> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isSeeking = false;
  bool _isLoading = true;
  bool _hasEnded = false;
  bool _showSpeedDropdown = false;
  final GlobalKey _speedButtonKey = GlobalKey();
  final AudioPlaybackProvider _playbackProvider = AudioPlaybackProvider();
  static final Map<String, SunoAudioPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    if (widget.separatePlayButton) {
      final controller = SunoAudioPlayerController();
      controller._attach(this);
      _controllers[widget.filePath] = controller;
    }
    _playbackProvider.addListener(_onPlaybackSpeedChanged);
    _initializePlayer();
  }

  void _onPlaybackSpeedChanged() {
    if (mounted) {
      _setPlaybackSpeed(_playbackProvider.playbackSpeed);
    }
  }

  Future<void> _initializePlayer() async {
    _player = AudioPlayer();

    try {
      debugPrint('Initializing audio player with file: ${widget.filePath}');

      // Handle different file path types
      if (kIsWeb ||
          widget.filePath.startsWith('blob:') ||
          widget.filePath.startsWith('http')) {
        await _player.setUrl(widget.filePath);
      } else {
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

      await Future.delayed(const Duration(milliseconds: 100));

      final duration = _player.duration;
      debugPrint('Audio duration: $duration');

      setState(() {
        _duration = duration ?? Duration.zero;
        _isLoading = false;
      });

      // Set initial playback speed from global state
      await _player.setSpeed(_playbackProvider.playbackSpeed);

      _player.positionStream.listen((pos) {
        if (!_isSeeking && mounted) {
          setState(() => _position = pos);
        }
      });

      _player.durationStream.listen((dur) {
        if (mounted) {
          debugPrint('Duration updated: $dur');
          setState(() => _duration = dur ?? Duration.zero);
        }
      });

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

            if (widget.onAudioEnded != null) {
              widget.onAudioEnded!();
            }
          } else {
            setState(() {
              _isPlaying = state.playing;
              if (state.playing) {
                _hasEnded = false;
                if (widget.onAudioStarted != null) {
                  widget.onAudioStarted!();
                }
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
  void didUpdateWidget(SunoAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _initializeFlags();
    }
  }

  Future<void> _initializeFlags() async {
    await _player.dispose();
    setState(() {
      _isLoading = true;
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
      _hasEnded = false;
    });
    _initializePlayer();
  }

  @override
  void dispose() {
    if (widget.separatePlayButton) {
      _controllers[widget.filePath]?._detach();
      _controllers.remove(widget.filePath);
    }
    _playbackProvider.removeListener(_onPlaybackSpeedChanged);
    _player.dispose();
    super.dispose();
  }

  void _closeDropdown() {
    if (_showSpeedDropdown) {
      setState(() {
        _showSpeedDropdown = false;
      });
    }
  }

  static Widget getPlayButton(String filePath) {
    return _controllers[filePath]?.playButton ?? SizedBox.shrink();
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
      if (_hasEnded && position < _duration) {
        setState(() => _hasEnded = false);
      }
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
      _playbackProvider.setPlaybackSpeed(speed);
    } catch (e) {
      debugPrint('Error setting playback speed: $e');
    }
  }

  Widget _buildPlayButton() {
    if (_hasEnded && widget.showReplayButton) {
      return IconButton(
        icon: Icon(
          Icons.replay_circle_filled_outlined,
          size: 60,
          color: AppColors.green,
        ),
        onPressed: _handleReplay,
        tooltip: 'Replay',
      );
    } else {
      return IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          size: 60,
          color: AppColors.green,
        ),
        onPressed: _handlePlayPause,
        tooltip: _isPlaying ? 'Pause' : 'Play',
      );
    }
  }

  Widget _buildSpeedButton() {
    final speeds = [0.5, 1.0, 2.0];
    return GestureDetector(
      key: _speedButtonKey,
      onTap: () {
        setState(() {
          _showSpeedDropdown = !_showSpeedDropdown;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_playbackProvider.playbackSpeed}x',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              _showSpeedDropdown
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.darkGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedDropdown() {
    final speeds = [0.5, 1.0, 2.0];
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 50.w,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.darkGreen),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: speeds.map((speed) {
            return GestureDetector(
              onTap: () {
                _setPlaybackSpeed(speed);
                setState(() {
                  _showSpeedDropdown = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: _playbackProvider.playbackSpeed == speed
                      ? AppColors.lightGreen4
                      : Colors.transparent,
                ),
                child: Text(
                  '${speed}x',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.darkGreen,
                    fontWeight: _playbackProvider.playbackSpeed == speed
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sliderColor = widget.activeColor ?? AppColors.darkGreen;
    final sliderBgColor = widget.inactiveColor ?? Colors.grey.shade300;
    final sliderH = widget.sliderHeight ?? 2.5;

    final sliderMax = _duration.inMilliseconds.toDouble() > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final sliderValue = _position.inMilliseconds.clamp(0.0, sliderMax);

    if (_isLoading) {
      return const Center(
        child: AudioPlayerSkeleton(),
      );
    }

    if (widget.separatePlayButton) {
      // Only return audio controls, play button accessed separately
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(40).r,
          border: Border.all(color: AppColors.darkGreen),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(width: 16.w),
                Text(
                  '${_formatTime(_position)}/${_formatTime(_duration)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _hasEnded
                        ? sliderColor.withValues(alpha: 0.7)
                        : AppColors.greys87,
                    fontWeight: _hasEnded ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
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
                SizedBox(width: 8.w),
                _buildSpeedButton(),
                SizedBox(width: 16.w),
              ],
            ),
            if (_showSpeedDropdown)
              Positioned(
                top: -130.h,
                right: 10.w,
                child: _buildSpeedDropdown(),
              ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Column(
            children: [
              // Audio progress bar with combined timer and speed button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(40).r,
                  border: Border.all(color: AppColors.darkGreen),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Text(
                      '${_formatTime(_position)}/${_formatTime(_duration)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _hasEnded
                            ? sliderColor.withValues(alpha: 0.7)
                            : AppColors.greys87,
                        fontWeight:
                            _hasEnded ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: sliderH,
                          activeTrackColor: sliderColor,
                          inactiveTrackColor: sliderBgColor,
                          thumbColor: sliderColor,
                          overlayColor: sliderColor.withValues(alpha: 0.2),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
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
                            await _seekTo(
                                Duration(milliseconds: value.toInt()));
                            setState(() => _isSeeking = false);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _buildSpeedButton(),
                    SizedBox(width: 16.w),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Play button centered below
              _buildPlayButton(),
            ],
          ),
          if (_showSpeedDropdown)
            Positioned(
              top: 50.h,
              right: 16.w,
              child: _buildSpeedDropdown(),
            ),
        ],
      );
    }
  }
}
