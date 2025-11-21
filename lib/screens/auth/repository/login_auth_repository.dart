import 'package:VoiceGive/screens/auth/model/auth_model.dart';
import 'package:flutter/material.dart';

import '../../../constants/storage_constants.dart';
import '../../../services/secure_storage_service.dart';
import '../service/login_auth_service.dart';

class LoginAuthRepository {
  static final _storage = SecureStorageService.instance.storage;

  // Implementation of login authentication repository
  Future<String?> sendOtp(String mobileNo, String countryCode) async {
    // Call the LoginAuthService to send the OTP
    try {
      var response = await LoginAuthService.sendOtp(
          mobileNo: mobileNo, countryCode: countryCode);
      if (response['data'] != null && response['data']['sessionId'] != null) {
        _storage.write(
            key: StorageConstants.sessionId,
            value: response['data']['sessionId'] ?? '');
      }
      return response['message'];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<String?> resendOtp(
      {required String mobileNo, required String countryCode}) async {
    // Call the LoginAuthService to resend the OTP
    try {
      var response = await LoginAuthService.resendOtp(
          mobileNo: mobileNo, countryCode: countryCode);
      return response['message'];
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<dynamic> verifyOtp(
      {required String otp, required String mobileNo}) async {
    // Call the LoginAuthService to verify the OTP
    try {
      var response =
          await LoginAuthService.verifyOtp(otp: otp, mobileNo: mobileNo);
      if (response['data'] == null) {
        return response['detail'] ?? 'Error occurred while verifying OTP';
      }
      return AuthModel.fromJson(response['data']);
    } catch (e) {
      debugPrint(e.toString());
      return 'Error occurred while verifying OTP';
    }
  }
}
