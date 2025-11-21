import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrl {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  static final String getSentancesForRecordingUrl =
      '$baseUrl/contributions/get-sentences';
  static final String sumbitAudioUrl = '$baseUrl/contributions/record';
  static final String reportIssueUrl = '$baseUrl/contributions/report';
  static final String contributeSessionCompleteUrl =
      '$baseUrl/contributions/session-complete';
  static final String sendOTPUrl = '$baseUrl/auth/send-otp';
  static final String resendOTPUrl = '$baseUrl/auth/resend-otp';
  static final String verifyOTPUrl = '$baseUrl/auth/verify-otp';
  static final String skipContributionUrl = '$baseUrl/contributions/skip';
  static final String getValidationsQueUrl = '$baseUrl/validations/get-queue';
  static final String submitValidationUrl = '$baseUrl/validations/submit';
  static final String validationSessionCompleteUrl =
      '$baseUrl/validations/session-complete';
  static final String getLanguages = '$baseUrl/admin/data/languages';
  static final String userRegisterUrl = '$baseUrl/users/register';
  static final String ageGroupUrl = '$baseUrl/admin/data/age-groups';
  static final String genderUrl = '$baseUrl/admin/data/genders';
  static final String countryUrl = '$baseUrl/admin/data/countries';
  static final String stateUrl = '$baseUrl/admin/data/states/';
  static final String districtUrl = '$baseUrl/admin/data/districts/';
  static final String languageUrl = '$baseUrl/admin/data/languages';
}
