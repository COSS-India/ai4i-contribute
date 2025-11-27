import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/app_colors.dart';
import '../../../config/branding_config.dart';
import '../../../constants/api_url.dart';
import 'package:volume_controller/volume_controller.dart';

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
  void initState() {
    super.initState();
    _listenToVolumeChanges();
  }

  void _listenToVolumeChanges() {
    VolumeController().listener((volume) {
      final newLevel = (volume * 10).round().clamp(1, 10);
      if (newLevel != volumeLevel) {
        setState(() {
          volumeLevel = newLevel;
        });
      }
    });
  }

  @override
  void dispose() {
    VolumeController().removeListener();
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
        await _audioPlayer.setVolume(volumeLevel / 10.0);
        await _audioPlayer.play(UrlSource(audioUrl!));
      } catch (e) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Future<void> _fetchAudioUrl() async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.testSpeakers),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final sampleAudio = data['data']['sample_audio'];
          setState(() {
            audioUrl = '${ApiUrl.baseUrl}$sampleAudio';
          });
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _setVolumeLevel(int level) async {
    setState(() {
      volumeLevel = level;
    });

    // Set audio player volume
    await _audioPlayer.setVolume(level / 10.0);

    // Set device volume (0.0 to 1.0)
    try {
      await _setSystemVolume(level / 10.0);
    } catch (e) {
      // Handle error silently
    }

    HapticFeedback.selectionClick();
  }

  Future<void> _setSystemVolume(double volume) async {
    try {
      VolumeController().setVolume(volume, showSystemUI: false);
    } catch (e) {
      // Handle error silently
    }
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
            Row(
              children: [
                // Speaker button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: AppColors.orange,
                      width: 2,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: startTest,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Image.asset(
                        'assets/images/volume.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Volume bars container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: AppColors.orange,
                        width: 2,
                      ),
                    ),
                    child: GestureDetector(
                      onTapUp: (details) {
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        final localPosition =
                            box.globalToLocal(details.globalPosition);
                        final containerWidth =
                            box.size.width - 24; // Account for padding
                        final relativeX =
                            (localPosition.dx - 12).clamp(0.0, containerWidth);
                        final volumePercent =
                            (relativeX / containerWidth).clamp(0.0, 1.0);
                        final newLevel =
                            ((volumePercent * 10).ceil()).clamp(1, 10);
                        _setVolumeLevel(newLevel);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = MediaQuery.of(context).size.width;
                            final int maxBars = screenWidth < 350 ? 6 : 10;
                            final int totalElements = (maxBars * 2) - 1; // bars + spacers
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                totalElements,
                                (index) {
                                  if (index.isEven) {
                                    // Volume bar
                                    final barIndex = index ~/ 2;
                                    return GestureDetector(
                                      onTap: () => _setVolumeLevel(((barIndex + 1) * 10 / maxBars).round()),
                                      child: _buildVolumeBar(barIndex, maxBars),
                                    );
                                  } else {
                                    // Transparent spacer
                                    return GestureDetector(
                                      onTap: () {
                                        final barIndex = (index + 1) ~/ 2;
                                        _setVolumeLevel(((barIndex * 10) / maxBars).round());
                                      },
                                      child: Container(
                                        width: 5,
                                        height: 40,
                                        color: Colors.transparent,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeBar(int index, int maxBars) {
    final double barThreshold = (index + 1) * 10 / maxBars;
    final bool isVolumeActive = volumeLevel >= barThreshold;

    return Container(
      width: 13,
      height: isVolumeActive ? 38 : 30,
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAF3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF23D088),
          width: 0.5,
        ),
      ),
    );
  }
}
