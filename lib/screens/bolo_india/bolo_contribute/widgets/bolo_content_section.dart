import 'dart:io';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef IntCallback = void Function(int value);
class BoloContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;
  const BoloContentSection({super.key, required this.language, required this.indexUpdate, required this.currentIndex});

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
  int currentIndex = 0;

  List<File?> recordedFiles = [];

  @override
  void initState() {
    boloContributeFuture = BoloContributeRepository()
        .getContributionSentances(language: widget.language.languageCode);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoloContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      currentIndex = 0;
      enableSubmit.value = false;
      recordedFile = null;
      boloContributeFuture = BoloContributeRepository()
          .getContributionSentances(language: widget.language.languageCode);
    }
    if(currentIndex != widget.currentIndex){
      currentIndex = widget.currentIndex;
    }
    if(recordedFiles.isNotEmpty && recordedFiles.length > currentIndex + 1){
      recordedFiles.removeLast();
    }
    if(mounted){
      setState(() {});
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
            child: Text("Something went wrong! Please try again."),
          ));
        }
        if (snapshot.data!.sentences.isEmpty) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Text(
              "No Contribution sentences, Available for this selected language.",
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ));
        }

        final List<Sentence> contributeSentences = snapshot.data!.sentences;
        final int sentencesLength = contributeSentences.length;
        final double progress = (currentIndex + 1) / sentencesLength;

        return Container(
          padding: EdgeInsets.all(12).r,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/contribute_bg.png"),
              fit: BoxFit.cover,
            ),
            color: AppColors.lightGreen3,
            borderRadius: BorderRadius.circular(8).r,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _progressHeader(progress: progress, total: sentencesLength),
              SizedBox(height: 24.w),
              _sentenceText(contributeSentences[currentIndex].text),
              SizedBox(height: 50.w),
              recordingButton(sentence: contributeSentences[currentIndex]),
              SizedBox(height: 30.w),
              _actionButtons(
                  length: sentencesLength,
                  currentSentence: contributeSentences[currentIndex]),
              SizedBox(height: 50.w),
            ],
          ),
        );
      },
    );
  }

  Widget _progressHeader({required int total, required double progress}) =>
      Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                "${currentIndex + 1}/$total",
                style: GoogleFonts.notoSans(
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
          style: GoogleFonts.notoSans(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget recordingButton({required Sentence sentence}) {
    return ValueListenableBuilder(
        valueListenable: skipLoading,
        builder: (context, skipvalue, child) {
          return ValueListenableBuilder(
              valueListenable: submitLoading,
              builder: (context, submitValue, child) {
                return submitValue || skipvalue
                    ? Column(
                        children: [
                          Text(skipvalue ? "Skipping..." : "Submitting...",
                              style: GoogleFonts.notoSans(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkGreen)),
                          SizedBox(
                            height: 50,
                          ),
                          CircleAvatar(
                              radius: 36.r,
                              backgroundColor: AppColors.lightGreen,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      )
                    : RecordingButton(
                        text: sentence.text,
                        isRecording: (RecordingState? state) {
                          debugPrint("Recording state changed: $state");
                          if (state != null &&
                              state == RecordingState.recording) {
                            enableSubmit.value = false;
                            enableSkip.value = false;
                          } else if (state != null &&
                              state == RecordingState.stopped) {
                            enableSkip.value = true;
                            enableSubmit.value = true;
                          }
                        },
                        getRecordedFile: (File? file) {
                          debugPrint("Received recorded file: ${file?.path}");
                          enableSubmit.value = file != null;
                          recordedFile = file;
                        },
                      );
              });
        });
  }

  Widget _actionButtons(
      {required Sentence currentSentence, required int length}) {
    final bool isSessionComplete = currentIndex >= length - 1;

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
          title: "Contribute More",
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
                  text: "Failed to complete session. Please try again.",
                );
              }
            }
          },
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _validateButton() => SizedBox(
        width: 140.w,
        child: PrimaryButtonWidget(
          title: "Validate",
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
                  text: "Failed to complete session. Please try again.",
                );
              }
            }
          },
          textColor: Colors.white,
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
              color: Colors.white,
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
            textColor: Colors.white,
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
        reason: "Not Clear",
        comment: "Noisy Environment",
      );
      BoloContributeSentence? contributeSentance = await boloContributeFuture;
      if (newSentence != null && contributeSentance != null) {
        contributeSentance.sentences[currentIndex] = newSentence;

        boloContributeFuture = Future.value(contributeSentance);
        if (mounted) {
          Helper.showSnackBarMessage(
            context: context,
            text: "Sentence skipped. Please contribute the new sentence.",
          );
        }
      } else {
        if (mounted) {
          Helper.showSnackBarMessage(
            context: context,
            text: "Failed to skip. Please try again.",
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
        text: "Please record your voice before submitting.",
      );
      return;
    }

    submitLoading.value = true;
    enableSkip.value = false;
    bool isSubmitted = false;

    if(recordedFile!=null){
      isSubmitted = await BoloContributeRepository().submitContributeAudio(
      duration: 10,
      sentenceId: currentSentence.sentenceId,
      sequenceNumber: currentSentence.sequenceNumber,
      audioFile: recordedFile!,
      languageCode: widget.language.languageCode,
    );

    }
    if (isSubmitted) {
      enableSubmit.value = true;
      recordedFile = null;
      await moveToNext();
      if (mounted) {
        Helper.showSnackBarMessage(
          context: context,
          text: "Your Contribution Submitted Successfully",
        );
      }
    } else {
      if (mounted) {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to submit. Please try again.",
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
