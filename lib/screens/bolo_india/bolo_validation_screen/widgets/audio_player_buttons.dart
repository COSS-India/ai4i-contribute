import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/branding_config.dart';

enum AudioPlayerButtonState { idle, playing, paused, replay, completed }

class AudioPlayerButtons extends StatefulWidget {
  final String audioUrl;
  final Function(AudioPlayerButtonState?) playerStatus;

  const AudioPlayerButtons({
    super.key,
    required this.playerStatus,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerButtons> createState() => _AudioPlayerButtonsState();
}

class _AudioPlayerButtonsState extends State<AudioPlayerButtons>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  AudioPlayerButtonState _state = AudioPlayerButtonState.idle;
  late AnimationController _controller;
  Duration? _audioDuration;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _stateSub;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _durationSub = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
        if (_audioDuration != null && pos >= _audioDuration!) {
          _controller.stop();
          _state = AudioPlayerButtonState.replay;
          widget.playerStatus.call(_state);
        }
      });
    });

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.completed) {
        setState(() {
          _controller.stop();
          _state = AudioPlayerButtonState.replay;
        });
        widget.playerStatus.call(_state);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl ||
        widget.audioUrl == oldWidget.audioUrl) {
      setState(() {
        _state = AudioPlayerButtonState.idle;
        _controller.reset();
        _audioPlayer.stop();
        _position = Duration.zero;
      });
    }
  }

  Future<void> _startPlayback() async {
    if (isMp3OrWavBase64(widget.audioUrl)) {
      Uint8List audioBytes = base64Decode(widget.audioUrl);

      await _audioPlayer.play(BytesSource(audioBytes));
      _controller.repeat();
    } else {
      // Handle invalid audio data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid audio data')),
      );
      setState(() {
        _state = AudioPlayerButtonState.idle;
      });
    }
  }

  Future<void> _pausePlayback() async {
    await _audioPlayer.pause();
    _controller.stop();
  }

  Future<void> _resumePlayback() async {
    await _audioPlayer.resume();
    _controller.repeat();
  }

  Future<void> _toggleState() async {
    switch (_state) {
      case AudioPlayerButtonState.idle:
        setState(() => _state = AudioPlayerButtonState.playing);
        await _startPlayback();
        break;
      case AudioPlayerButtonState.playing:
        setState(() => _state = AudioPlayerButtonState.paused);
        await _pausePlayback();
        break;
      case AudioPlayerButtonState.paused:
        setState(() => _state = AudioPlayerButtonState.playing);
        await _resumePlayback();
        break;
      case AudioPlayerButtonState.replay:
      case AudioPlayerButtonState.completed:
        setState(() => _state = AudioPlayerButtonState.playing);
        await _startPlayback();
        break;
    }
    widget.playerStatus.call(_state);
  }

  TextStyle get _textStyle => BrandingConfig.instance.getPrimaryTextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGreen,
      );

  Widget _buildPulsingIndicator() {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_state == AudioPlayerButtonState.playing)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: List.generate(3, (index) {
                    final progress = (_controller.value + index / 3) % 1.0;
                    final scale = 1.0 + progress * 2.0;
                    final opacity = (1 - progress).clamp(0.0, 1.0);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lightGreen
                              .withValues(alpha: opacity * 0.3),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.lightGreen,
            child: Icon(Icons.pause, size: 40.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    String text;
    IconData? icon;
    Widget buttonContent;

    switch (_state) {
      case AudioPlayerButtonState.idle:
        text = "Play Recording";
        icon = Icons.play_arrow;
        buttonContent = CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.lightGreen.withValues(alpha: 0.9),
            child: Icon(icon, size: 40.sp, color: Colors.white));
        break;
      case AudioPlayerButtonState.playing:
        text = "Pause Recording";
        buttonContent = _buildPulsingIndicator();
        break;
      case AudioPlayerButtonState.paused:
        text = "Resume Recording";
        icon = Icons.play_arrow;
        buttonContent = CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.lightGreen.withValues(alpha: 0.9),
            child: Icon(icon, size: 40.sp, color: Colors.white));
        break;
      case AudioPlayerButtonState.replay:
      case AudioPlayerButtonState.completed:
        text = "Replay Recording";
        icon = Icons.replay;
        buttonContent = CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.lightGreen.withValues(alpha: 0.9),
            child: Icon(icon, size: 40.sp, color: Colors.white));
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: _textStyle),
        SizedBox(height: 36.h),
        GestureDetector(
          onTap: _toggleState,
          child: buttonContent,
        ),
        SizedBox(height: 36.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  bool isMp3OrWavBase64(String base64Str) {
    Uint8List bytes;
    try {
      bytes = base64Decode(base64Str);
    } catch (_) {
      return false;
    }

    if (bytes.length < 4) return false;

    // MP3 magic numbers
    if ((bytes[0] == 255 && bytes[1] == 251) || // FF FB
        (bytes[0] == 73 && bytes[1] == 68 && bytes[2] == 51)) {
      // ID3
      return true;
    }

    // WAV magic number
    if (bytes[0] == 82 && bytes[1] == 73 && bytes[2] == 70 && bytes[3] == 70) {
      // RIFF
      return true;
    }

    return false;
  }
}
