import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/searchable_bottom_sheet/searchable_boottosheet_content.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/profile_screen/model/age_group_model.dart';
import 'package:VoiceGive/screens/profile_screen/repository/profile_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/screens/auth/otp_login/otp_verification_screen.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:VoiceGive/screens/profile_screen/screens/other_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_constants.dart';
import '../model/gender_model.dart';
import '../widgets/name_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;

  const ProfileScreen({super.key, this.phoneNumber, this.countryCode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _ageFieldKey = GlobalKey();
  final GlobalKey _genderFieldKey = GlobalKey();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _selectedAgeGroup;
  String? _selectedGender;

  List<AgeModel> _ageGroups = [];
  List<GenderModel> _genders = [];
  List<String> _ageList = [];
  List<String> _genderList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickFromList({
    required List<String> items,
    required ValueChanged<String> onPicked,
    String? defaultItem,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomSheetContext) => SearchableBottomSheetContent(
        items: items,
        hasMore: false,
        initialQuery: '',
        defaultItem: defaultItem,
        onItemSelected: (value) {
          onPicked(value);
          Navigator.of(bottomSheetContext).pop();
        },
        parentContext: bottomSheetContext,
      ),
    );
  }

  InputBorder _outline(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: color),
      );

  Future<bool> _navigateBackToOtp() async {
    if (widget.phoneNumber != null && !widget.phoneNumber!.contains('@')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
              phoneNumber: widget.phoneNumber!,
              countryCode: widget.countryCode!),
        ),
      );
    } else {
      // If no phone number or email, go to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _navigateBackToOtp();
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Full-width orange header outside content padding
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16).r,
                decoration: BoxDecoration(color: AppColors.orange),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _navigateBackToOtp,
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.white,
                          size: 36.sp,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.completeYourProfile,
                      style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          Text(
                            AppLocalizations.of(context)!.personalInformation,
                            style: GoogleFonts.notoSans(
                              color: AppColors.greys87,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // First name
                          NameWidget(
                            nameController: _firstNameController,
                            helperText: AppLocalizations.of(context)!.firstName,
                            emptyErrorMsg: AppLocalizations.of(context)!
                                .firstNameMandatory,
                          ),
                          SizedBox(height: 16.h),
                          // Last name
                          NameWidget(
                            nameController: _lastNameController,
                            helperText: AppLocalizations.of(context)!.lastName,
                            emptyErrorMsg:
                                AppLocalizations.of(context)!.lastNameMandatory,
                          ),
                          SizedBox(height: 16.h),
                          // Age group picker (read-only TextField with in-box label)
                          KeyedSubtree(
                            key: _ageFieldKey,
                            child: TextFormField(
                              controller: _ageController,
                              readOnly: true,
                              onTap: () => _pickFromList(
                                items: _ageList,
                                defaultItem: _selectedAgeGroup,
                                onPicked: (value) {
                                  setState(() {
                                    _selectedAgeGroup = value;
                                    _ageController.text = value;
                                  });
                                  final ctx = _ageFieldKey.currentContext;
                                  if (ctx != null) {
                                    Future.microtask(() =>
                                        Scrollable.ensureVisible(
                                          ctx,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          alignment: 0.1,
                                        ));
                                  }
                                },
                              ),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '*',
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.negativeLight,
                                          fontSize: 14.sp),
                                    ),
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .chooseYourAgeGroup,
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.greys60,
                                          fontSize: 14.sp),
                                    ),
                                  ]),
                                ),
                                border: _outline(AppColors.grey40),
                                enabledBorder: _outline(AppColors.grey40),
                                focusedBorder: _outline(AppColors.grey40),
                                suffixIcon: Icon(Icons.keyboard_arrow_down,
                                    color: AppColors.greys87, size: 20.w),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 16.w),
                              ),
                              style: GoogleFonts.notoSans(
                                  color: AppColors.greys87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Gender picker (read-only TextField with in-box label)
                          KeyedSubtree(
                            key: _genderFieldKey,
                            child: TextFormField(
                              controller: _genderController,
                              readOnly: true,
                              onTap: () => _pickFromList(
                                items: _genderList,
                                defaultItem: _selectedGender,
                                onPicked: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                    _genderController.text = value;
                                  });
                                  final ctx = _genderFieldKey.currentContext;
                                  if (ctx != null) {
                                    Future.microtask(() =>
                                        Scrollable.ensureVisible(
                                          ctx,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          alignment: 0.1,
                                        ));
                                  }
                                },
                              ),
                              decoration: InputDecoration(
                                label: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '*',
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.negativeLight,
                                          fontSize: 14.sp),
                                    ),
                                    TextSpan(
                                      text:
                                          AppLocalizations.of(context)!.gender,
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.greys60,
                                          fontSize: 14.sp),
                                    ),
                                  ]),
                                ),
                                border: _outline(AppColors.grey40),
                                enabledBorder: _outline(AppColors.grey40),
                                focusedBorder: _outline(AppColors.grey40),
                                suffixIcon: Icon(Icons.keyboard_arrow_down,
                                    color: AppColors.greys87, size: 20.w),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 16.w),
                              ),
                              style: GoogleFonts.notoSans(
                                  color: AppColors.greys87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Phone number (read-only) - only show if phone number is provided and not an email
                          if (widget.phoneNumber != null &&
                              !widget.phoneNumber!.contains('@'))
                            TextFormField(
                              initialValue: '+91 ${widget.phoneNumber}',
                              readOnly: true,
                              decoration: InputDecoration(
                                enabled: false,
                                enabledBorder: _outline(AppColors.grey40),
                                fillColor: AppColors.lightGrey2,
                                filled: true,
                                disabledBorder: _outline(AppColors.darkGrey),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 12.w),
                              ),
                              style: GoogleFonts.notoSans(
                                  color: AppColors.darkGreen,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          SizedBox(height: 16.h),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.emailId,
                              labelStyle: GoogleFonts.notoSans(
                                  color: AppColors.greys60, fontSize: 14.sp),
                              enabledBorder: _outline(AppColors.grey40),
                              focusedBorder: _outline(AppColors.grey40),
                              errorBorder: _outline(AppColors.negativeLight),
                              focusedErrorBorder:
                                  _outline(AppColors.negativeLight),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 12.w),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                String? matchedString = RegExpressions
                                    .validEmail
                                    .stringMatch(value);
                                if (matchedString == null ||
                                    matchedString.isEmpty ||
                                    matchedString.length != value.length) {
                                  return AppLocalizations.of(context)!
                                      .enterValidEmail;
                                }
                                return null;
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.notoSans(
                                color: AppColors.greys87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 60.h),
                          Center(
                            child: SizedBox(
                              width: 280.w,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final valid =
                                      _formKey.currentState?.validate() ??
                                          false;
                                  final selectionsValid =
                                      _ageController.text.isNotEmpty &&
                                          _genderController.text.isNotEmpty;
                                  setState(() {});
                                  if (valid && selectionsValid) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => OtherInformationScreen(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          ageGroup: getAgeGroupValue(
                                              _ageController.text),
                                          gender: getGenderValue(
                                              _genderController.text),
                                          phoneNumber: widget.phoneNumber ?? '',
                                          email:
                                              _emailController.text.isNotEmpty
                                                  ? _emailController.text
                                                  : null,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(AppLocalizations.of(
                                                  context)!
                                              .pleaseSelectAgeGroupAndGender)),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.w),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.saveAndContinue,
                                  style: GoogleFonts.notoSans(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    _ageGroups = await ProfileRepository().getAgeGroup();
    _genders = await ProfileRepository().getGender();
    _ageList = _ageGroups.map((e) => e.label).toList();
    _genderList = _genders.map((e) => e.label).toList();

    if (mounted) {
      setState(() {});
    }
  }

  String getAgeGroupValue(String label) {
    return _ageGroups.firstWhere((element) => element.label == label).value;
  }

  String getGenderValue(String label) {
    return _genders.firstWhere((element) => element.label == label).value;
  }
}
