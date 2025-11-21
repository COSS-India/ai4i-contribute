import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/searchable_bottom_sheet/searchable_boottosheet_content.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/profile_screen/model/country_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/bolo_get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/district_model.dart';
import '../model/language_model.dart';
import '../model/state_model.dart';
import '../repository/profile_repository.dart';

class OtherInformationScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String ageGroup;
  final String gender;
  final String phoneNumber;
  final String? email;
  const OtherInformationScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.ageGroup,
      required this.gender,
      required this.phoneNumber,
      this.email});

  @override
  State<OtherInformationScreen> createState() => _OtherInformationScreenState();
}

class _OtherInformationScreenState extends State<OtherInformationScreen> {
  String _country = '';
  String _state = '';
  String? _district;
  String? _preferredLanguage;
  final GlobalKey _districtFieldKey = GlobalKey();
  bool _showDistrictError = false;
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  List<String> _countries = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _languages = [];
  List<CountryModel> countryList = [];
  List<StateModel> stateList = [];
  List<LanguageModel> languagesList = [];
  List<DistrictModel> districtList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    countryList = await ProfileRepository().getCountries();
    languagesList = await ProfileRepository().getLanguages();
    _countries = countryList.map((e) => e.countryName).toList();
    _languages = languagesList.map((e) => e.languageName).toList();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickFromList({
    required List<String> items,
    required ValueChanged<String> onPicked,
    String? defaultItem,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomCtx) => SearchableBottomSheetContent(
        items: items,
        hasMore: false,
        initialQuery: '',
        defaultItem: defaultItem,
        onItemSelected: (value) {
          onPicked(value);
          Navigator.of(bottomCtx).pop();
        },
        parentContext: bottomCtx,
      ),
    );
  }

  InputBorder _outline(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
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
                        onTap: () => Navigator.pop(context),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.otherInformation,
                          style: GoogleFonts.notoSans(
                            color: AppColors.greys87,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Country
                        GestureDetector(
                          onTap: () => _pickFromList(
                              items: _countries,
                              defaultItem: _country,
                              onPicked: (v) async {
                                // Check if country actually changed
                                if (_country != v) {
                                  _country = v;
                                  
                                  // Clear dependent fields
                                  _state = '';
                                  _district = null;
                                  _districtController.clear();
                                  _states = [];
                                  _districts = [];
                                  stateList = [];
                                  districtList = [];
                                  _showDistrictError = false;
                                  
                                  // Fetch states for new country
                                  String countryId = getCountryId(_country);
                                  stateList = await ProfileRepository()
                                      .getState(countryId);
                                  _states =
                                      stateList.map((e) => e.stateName).toList();
                                  
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              }),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              label: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '*',
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.negativeLight,
                                          fontSize: 14.sp)),
                                  TextSpan(
                                      text:
                                          AppLocalizations.of(context)!.country,
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.greys60,
                                          fontSize: 14.sp)),
                                ]),
                              ),
                              border: _outline(AppColors.darkGrey),
                              enabledBorder: _outline(AppColors.darkGrey),
                              focusedBorder: _outline(AppColors.darkGrey),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 16.w),
                              suffixIcon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.greys87, size: 20.w),
                            ),
                            child: Text(
                              _country,
                              style: GoogleFonts.notoSans(
                                  color: AppColors.greys87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // State
                        GestureDetector(
                          onTap: _states.isEmpty
                              ? null
                              : () => _pickFromList(
                                    items: _states,
                                    defaultItem: _state,
                                    onPicked: (v) async {
                                      // Check if state actually changed
                                      if (_state != v) {
                                        _state = v;
                                        
                                        // Clear dependent fields
                                        _district = null;
                                        _districtController.clear();
                                        _districts = [];
                                        districtList = [];
                                        _showDistrictError = false;
                                        
                                        // Fetch districts for new state
                                        String stateId = getStateId(_state);
                                        districtList = await ProfileRepository()
                                            .getDistrict(stateId);
                                        _districts = districtList
                                            .map((e) => e.districtName)
                                            .toList();
                                        
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      }
                                    },
                                  ),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              label: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '*',
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.negativeLight,
                                          fontSize: 14.sp)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!.state,
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.greys60,
                                          fontSize: 14.sp)),
                                ]),
                              ),
                              border: _outline(AppColors.darkGrey),
                              enabledBorder: _outline(AppColors.darkGrey),
                              focusedBorder: _outline(AppColors.darkGrey),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 16.w),
                              suffixIcon: Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.greys87, size: 20.w),
                            ),
                            child: Text(
                              _state,
                              style: GoogleFonts.notoSans(
                                  color: AppColors.greys87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // District (required) as read-only TextField
                        KeyedSubtree(
                          key: _districtFieldKey,
                          child: TextFormField(
                            controller: _districtController,
                            readOnly: true,
                            onTap: _districts.isEmpty
                                ? null
                                : () => _pickFromList(
                                      items: _districts,
                                      defaultItem: _district,
                                      onPicked: (v) => setState(() {
                                        _district = v;
                                        _districtController.text = v;
                                        _showDistrictError = false;
                                      }),
                                    ),
                            decoration: InputDecoration(
                              label: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '*',
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.negativeLight,
                                          fontSize: 14.sp)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .district,
                                      style: GoogleFonts.notoSans(
                                          color: AppColors.greys60,
                                          fontSize: 14.sp)),
                                ]),
                              ),
                              border: _outline(AppColors.darkGrey),
                              enabledBorder: _outline(AppColors.darkGrey),
                              focusedBorder: _outline(AppColors.darkGrey),
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
                        if (_showDistrictError && _district == null)
                          Padding(
                            padding: EdgeInsets.only(top: 6.w, left: 8.w),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .thisFieldIsRequiredToContinue,
                              style: GoogleFonts.notoSans(
                                color: AppColors.negativeLight,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        SizedBox(height: 16.h),
                        // Preferred Language as read-only TextField
                        TextFormField(
                          controller: _languageController,
                          readOnly: true,
                          onTap: () => _pickFromList(
                            items: _languages,
                            defaultItem: _preferredLanguage,
                            onPicked: (v) => setState(() {
                              _preferredLanguage = v;
                              _languageController.text = v;
                            }),
                          ),
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.preferredLanguage,
                            labelStyle: GoogleFonts.notoSans(
                                color: AppColors.greys60, fontSize: 14.sp),
                            border: _outline(AppColors.darkGrey),
                            enabledBorder: _outline(AppColors.darkGrey),
                            focusedBorder: _outline(AppColors.darkGrey),
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
                        SizedBox(height: 60.h),
                        Center(
                          child: SizedBox(
                            width: 280.w,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_district == null) {
                                  setState(() => _showDistrictError = true);
                                  final ctx = _districtFieldKey.currentContext;
                                  if (ctx != null) {
                                    Future.microtask(() =>
                                        Scrollable.ensureVisible(
                                          ctx,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          alignment: 0.1,
                                        ));
                                  }
                                  return;
                                }
                                dynamic userData = await ProfileRepository()
                                    .registration(
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        ageGroup: widget.ageGroup,
                                        gender: widget.gender,
                                        mobileNo: widget.phoneNumber,
                                        country: _country,
                                        state: _state,
                                        district: _districtController.text,
                                        email: widget.email,
                                        preferredLanguage: _preferredLanguage);
                                if (userData is String) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(userData),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const BoloGetStarted(),
                                  ),
                                );
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
                                  fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }

  String getCountryId(String countryName) {
    return countryList
        .firstWhere((element) => element.countryName == countryName)
        .countryId;
  }

  String getStateId(String stateName) {
    return stateList
        .firstWhere((element) => element.stateName == stateName)
        .stateId;
  }
}