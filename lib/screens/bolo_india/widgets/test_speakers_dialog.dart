import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/app_colors.dart';
import '../../../config/branding_config.dart';
import '../../../constants/api_url.dart';

class TestSpeakersDialog extends StatefulWidget {
  const TestSpeakersDialog({Key? key}) : super(key: key);

  @override
  State<TestSpeakersDialog> createState() => _TestSpeakersDialogState();
}

class _TestSpeakersDialogState extends State<TestSpeakersDialog> {
  bool isPlaying = false;
  int volumeLevel = 5; // 0-10 volume levels
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? audioUrl;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void startTest() async {
    if (audioUrl == null) {
      await _fetchAudioUrl();
    }
    
    if (audioUrl != null) {
      setState(() {
        isPlaying = true;
      });

      try {
        print('Playing audio from: $audioUrl');
        await _audioPlayer.setVolume(volumeLevel / 10.0);
        await _audioPlayer.play(UrlSource(audioUrl!));
        print('Audio playback started');
      } catch (e) {
        print('Audio playback error: $e');
        // No seek bar animation
      }
    } else {
      print('No audio URL available');
    }
  }

  Future<void> _fetchAudioUrl() async {
    final fallbackUrl = 'http://3.7.77.1:9000/suno/static/sample1.mp3';
    print('Using fallback audio URL: $fallbackUrl');
    setState(() {
      audioUrl = fallbackUrl;
    });
  }



  void _setVolumeLevel(int level) async {
    setState(() {
      volumeLevel = level;
    });
    
    // Set audio player volume
    await _audioPlayer.setVolume(level / 10.0);
    print('Audio player volume set to: ${level / 10.0}');
    
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  'Test Your Speakers',
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greys87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Speaker test container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.orange,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Speaker button
                  GestureDetector(
                    onTap: startTest,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        border: Border(
                          right: BorderSide(
                            color: AppColors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.volume_up,
                        color: AppColors.darkGreen,
                        size: 32,
                      ),
                    ),
                  ),
                  // Volume bars container
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          10,
                          (index) => Padding(
                            padding: EdgeInsets.only(right: index == 9 ? 0 : 6),
                            child: GestureDetector(
                              onTap: () => _setVolumeLevel(index + 1),
                              child: _buildVolumeBar(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildVolumeBar(int index) {
    final bool isVolumeActive = index < volumeLevel;
    
    return Container(
      width: 10,
      height: 40,
      decoration: BoxDecoration(
        color: isVolumeActive
            ? AppColors.darkGreen
            : AppColors.lightGreen3,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}