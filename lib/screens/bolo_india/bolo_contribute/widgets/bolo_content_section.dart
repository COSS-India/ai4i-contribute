import 'dart:io';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/common_widgets/audio_player/custom_audio_player.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_contribute/widgets/recording_icon.dart';
import 'package:VoiceGive/screens/bolo_india/models/bolo_contribute_sentence.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/models/session_completed_model.dart';
import 'package:VoiceGive/screens/bolo_india/repository/bolo_contribute_repository.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_contribute/bolo_contribute.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_validation_screen/bolo_validation_screen.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_content_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../config/branding_config.dart';

typedef IntCallback = void Function(int value);

class BoloContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;
  const BoloContentSection(
      {super.key,
      required this.language,
      required this.indexUpdate,
      required this.currentIndex});

  @override
  State<BoloContentSection> createState() => _BoloContentSectionState();
}

class _BoloContentSectionState extends State<BoloContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> enableSkip = ValueNotifier<bool>(true);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> skipLoading = ValueNotifier<bool>(false);

  late Future<BoloContributeSentence?> boloContributeFuture;

  File? recordedFile;
  File? lastRecordedFile; // For validation screen
  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;

  List<File?> recordedFiles = [];

  @override
  void initState() {
    boloContributeFuture = BoloContributeRepository()
        .getContributionSentances(language: widget.language.languageName);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoloContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      // Reset ALL counters and state when language changes
      currentIndex = 0;
      submittedCount = 0;
      totalContributions = 5;
      enableSubmit.value = false;
      enableSkip.value = true;
      recordedFile = null;
      lastRecordedFile = null;
      recordedFiles.clear();
      boloContributeFuture = BoloContributeRepository()
          .getContributionSentances(language: widget.language.languageName);
      setState(() {});
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
    }
    if (recordedFiles.isNotEmpty && recordedFiles.length > currentIndex + 1) {
      recordedFiles.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BoloContributeSentence?>(
      future: boloContributeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BoloContentSkeleton();
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Text(AppLocalizations.of(context)!.noContentInLanguage),
          ));
        }
        if (snapshot.data!.sentences.isEmpty) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Text(
              AppLocalizations.of(context)!.noContributionSentences,
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ));
        }

        final List<Sentence> contributeSentences = snapshot.data!.sentences;
        final int sentencesLength = contributeSentences.length;
        final int currentItemNumber = submittedCount >= totalContributions
            ? totalContributions
            : submittedCount + 1;
        final double progress = currentItemNumber / totalContributions;
        final bool isSessionComplete = submittedCount >= totalContributions;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(
              color: Colors.grey[700]!,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8).r,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Image.asset(
                  'assets/images/contribute_bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  color: BrandingConfig.instance.primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.all(12).r,
                  child: Column(
                    children: [
                      _progressHeader(
                          progress: progress,
                          total: totalContributions,
                          currentItem: currentItemNumber),
                      SizedBox(height: 24.w),
                      _sentenceText(contributeSentences[currentIndex].text),
                      SizedBox(height: 50.w),
                      recordingButton(
                          sentence: contributeSentences[currentIndex]),
                      SizedBox(height: 30.w),
                      _actionButtons(
                          length: sentencesLength,
                          currentSentence: contributeSentences[currentIndex]),
                      SizedBox(height: 50.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _progressHeader(
          {required int total,
          required double progress,
          required int currentItem}) =>
      Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                "$currentItem/$total",
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 12.sp,
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.w),
          SizedBox(
            height: 4.0,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGreen4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
            ),
          )
        ],
      );

  Widget _sentenceText(String text) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Text(
          text,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget recordingButton({required Sentence sentence}) {
    final bool isSessionComplete = submittedCount >= totalContributions;

    return ValueListenableBuilder(
        valueListenable: skipLoading,
        builder: (context, skipvalue, child) {
          return ValueListenableBuilder(
              valueListenable: submitLoading,
              builder: (context, submitValue, child) {
                if (submitValue || skipvalue) {
                  return Column(
                    children: [
                      Text(
                          skipvalue
                              ? AppLocalizations.of(context)!.skipping
                              : AppLocalizations.of(context)!.submitting,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreen)),
                      SizedBox(height: 50),
                      CircleAvatar(
                          radius: 36.r,
                          backgroundColor: AppColors.lightGreen,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(height: 50),
                    ],
                  );
                }

                // When session is complete, show disabled audio player
                if (isSessionComplete && lastRecordedFile != null) {
                  return Column(
                    children: [
                      // Same layout as screen 2 but disabled
                      Column(
                        children: [
                          SizedBox(height: 8.w),
                          IgnorePointer(
                            child: CustomAudioPlayer(
                              filePath: lastRecordedFile!.path,
                              activeColor: AppColors.darkGreen,
                            ),
                          ),
                          SizedBox(height: 16.w),
                          Text(
                            AppLocalizations.of(context)!.reRecord,
                            style: BrandingConfig.instance.getPrimaryTextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      // Disabled record button with same spacing as original
                      IgnorePointer(
                        child: SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            radius: 36.r,
                            backgroundColor: AppColors.darkGreen,
                            child: Icon(
                              Icons.mic_outlined,
                              size: 45.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return RecordingButton(
                  text: sentence.text,
                  isDisabled: isSessionComplete,
                  isRecording: (RecordingState? state) {
                    if (!isSessionComplete) {
                      debugPrint("Recording state changed: $state");
                      if (state != null && state == RecordingState.recording) {
                        enableSubmit.value = false;
                        enableSkip.value = false;
                      } else if (state != null &&
                          state == RecordingState.stopped) {
                        enableSkip.value = true;
                        enableSubmit.value = true;
                      }
                    }
                  },
                  getRecordedFile: (File? file) {
                    if (!isSessionComplete) {
                      debugPrint("Received recorded file: ${file?.path}");
                      enableSubmit.value = file != null;
                      recordedFile = file;
                    }
                  },
                );
              });
        });
  }

  Widget _actionButtons(
      {required Sentence currentSentence, required int length}) {
    final bool isSessionComplete = submittedCount >= totalContributions;

    if (isSessionComplete) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _contributeMoreButton(),
          SizedBox(width: 24.w),
          _validateButton(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _skipButton(currentSentence: currentSentence),
          SizedBox(width: 24.w),
          _submitButton(currentSentence),
        ],
      );
    }
  }

  Widget _contributeMoreButton() => SizedBox(
        width: 180.w,
        child: PrimaryButtonWidget(
          title: AppLocalizations.of(context)!.contributeMore,
          textFontSize: 16.sp,
          onTap: () async {
            if (await onSessionComplete()) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoloContribute(),
                  ),
                );
              }
            } else {
              if (mounted) {
                Helper.showSnackBarMessage(
                  context: context,
                  text: AppLocalizations.of(context)!.failedToCompleteSession,
                );
              }
            }
          },
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _validateButton() => SizedBox(
        width: 140.w,
        child: PrimaryButtonWidget(
          title: AppLocalizations.of(context)!.validate,
          textFontSize: 16.sp,
          onTap: () async {
            if (await onSessionComplete()) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoloValidationScreen(),
                  ),
                );
              }
            } else {
              if (mounted) {
                Helper.showSnackBarMessage(
                  context: context,
                  text: AppLocalizations.of(context)!.failedToCompleteSession,
                );
              }
            }
          },
          textColor: AppColors.backgroundColor,
          decoration: BoxDecoration(
            color: AppColors.orange,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _skipButton({required Sentence currentSentence}) =>
      ValueListenableBuilder<bool>(
        valueListenable: enableSkip,
        builder: (context, enableSkipValue, child) => SizedBox(
          width: 120.w,
          child: PrimaryButtonWidget(
            title: AppLocalizations.of(context)!.skip,
            textFontSize: 16.sp,
            isLoading: skipLoading,
            isLightTheme: true,
            onTap: () {
              onSkip(currentSentence: currentSentence);
            },
            textColor: enableSkipValue ? AppColors.orange : AppColors.grey16,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border.all(
                color: enableSkipValue ? AppColors.orange : AppColors.grey16,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.0).r),
            ),
          ),
        ),
      );

  Widget _submitButton(Sentence currentSentence) =>
      ValueListenableBuilder<bool>(
        valueListenable: enableSubmit,
        builder: (context, enableSubmitValue, child) => SizedBox(
          width: 120.w,
          child: PrimaryButtonWidget(
            isLoading: submitLoading,
            title: AppLocalizations.of(context)!.submit,
            textFontSize: 16.sp,
            onTap: () => onSubmit(
              submitEnabled: enableSubmitValue,
              currentSentence: currentSentence,
            ),
            textColor: AppColors.backgroundColor,
            decoration: BoxDecoration(
              color: enableSubmitValue ? AppColors.orange : AppColors.grey16,
              border: Border.all(
                color: enableSubmitValue ? AppColors.orange : AppColors.grey16,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.0).r),
            ),
          ),
        ),
      );

  void onSkip({required Sentence currentSentence}) async {
    if (!enableSkip.value || skipLoading.value) return;
    skipLoading.value = true;
    enableSubmit.value = false;
    try {
      Sentence? newSentence = await BoloContributeRepository().skipContribution(
        sentenceId: currentSentence.sentenceId,
        reason: AppLocalizations.of(context)!.notClear,
        comment: AppLocalizations.of(context)!.noisyEnvironment,
      );
      BoloContributeSentence? contributeSentance = await boloContributeFuture;
      if (newSentence != null && contributeSentance != null) {
        contributeSentance.sentences[currentIndex] = newSentence;

        boloContributeFuture = Future.value(contributeSentance);
        if (mounted) {
          Helper.showSnackBarMessage(
            context: context,
            text: AppLocalizations.of(context)!.sentenceSkipped,
          );
        }
      } else {
        if (mounted) {
          Helper.showSnackBarMessage(
            context: context,
            text: AppLocalizations.of(context)!.failedToSkip,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to skip. Please try again.",
        );
      }
    } finally {
      setState(() {});

      skipLoading.value = false;
      enableSubmit.value = false;
    }
  }

  Future<void> onSubmit({
    required bool submitEnabled,
    required Sentence currentSentence,
  }) async {
    if (submitLoading.value) return;
    if (!enableSubmit.value || recordedFile == null) {
      Helper.showSnackBarMessage(
        context: context,
        text: AppLocalizations.of(context)!.pleaseRecordVoice,
      );
      return;
    }

    submitLoading.value = true;
    enableSkip.value = false;
    bool isSubmitted = false;

    if (recordedFile != null) {
      isSubmitted = await BoloContributeRepository().submitContributeAudio(
        duration: 10,
        sentenceId: currentSentence.sentenceId,
        sequenceNumber: currentSentence.sequenceNumber,
        audioFile: recordedFile!,
        languageCode: widget.language.languageCode,
      );
    }
    if (isSubmitted) {
      submittedCount++;
      enableSubmit.value = true;
      
      if (submittedCount < totalContributions) {
        await moveToNext();
      } else {
        // Store last recorded file for validation screen
        lastRecordedFile = recordedFile;
        recordedFile = null;
        setState(() {});
      }

      if (mounted) {
        Helper.showSnackBarMessage(
          context: context,
          text: AppLocalizations.of(context)!.contributionSubmittedSuccessfully,
        );
      }
    } else {
      if (mounted) {
        Helper.showSnackBarMessage(
          context: context,
          text: AppLocalizations.of(context)!.failedToSubmit,
        );
      }
    }
    enableSkip.value = true;
    submitLoading.value = false;
  }

  Future moveToNext() async {
    List<Sentence> contributeSentences =
        (await boloContributeFuture)?.sentences ?? [];
    if (currentIndex < contributeSentences.length - 1) {
      widget.indexUpdate(currentIndex + 1);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoloValidationScreen(),
        ),
      );
    }
    recordedFile = null;
    enableSubmit.value = false;
  }

  Future<bool> onSessionComplete() async {
    SessionCompletedData? data =
        await BoloContributeRepository().completeSession();
    if (data != null) {
      return true;
    } else {
      return false;
    }
  }
}
