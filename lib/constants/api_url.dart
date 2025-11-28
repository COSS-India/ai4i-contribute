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
  
  // Likho URLs
  static final String likhoQueueUrl = '$baseUrl/likho/queue';
  static final String likhoSubmitUrl = '$baseUrl/likho/submit';
  static final String likhoValidationUrl = '$baseUrl/likho/validation';
  static final String likhoValidationCorrectUrl = '$baseUrl/likho/validation/correct';
  static final String likhoValidationCorrectionUrl = '$baseUrl/likho/validation/submit-correction';
  
  // Dekho URLs
  static final String dekhoQueueUrl = '$baseUrl/dekho/queue';
  static final String dekhoSubmitUrl = '$baseUrl/dekho/submit';
  static final String dekhoValidationUrl = '$baseUrl/dekho/validation';
  static final String dekhoValidationCorrectUrl = '$baseUrl/dekho/validation/correct';
  static final String dekhoValidationCorrectionUrl = '$baseUrl/dekho/validation/submit-correction';
  
  // Suno URLs
  static final String sunoQueueUrl = '$baseUrl/suno/queue';
  static final String sunoSubmitUrl = '$baseUrl/suno/submit';
  static final String sunoValidationUrl = '$baseUrl/suno/validation';
  static final String sunoValidationCorrectUrl = '$baseUrl/suno/validation/correct';
  
  // Test Speakers URL
  static final String testSpeakers = '$baseUrl/suno/test-speaker';
}
