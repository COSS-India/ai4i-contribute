import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants/api_url.dart';
class LoginAuthService {
  static Future<dynamic> sendOtp({required String mobileNo, required String countryCode}) async {
    
    Map body = {
      'mobileNo': mobileNo,
      'countryCode': countryCode
    };

    final response = await http.post(
        Uri.parse(ApiUrl.sendOTPUrl),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(body));
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> resendOtp({required String mobileNo,required String countryCode}) async {
    
    Map body = {
      'mobileNo': mobileNo,
      'countryCode': countryCode
    };

    final response = await http.post(
        Uri.parse(ApiUrl.resendOTPUrl),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(body));
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> verifyOtp({required String otp, required String sessionId}) async {
    
    Map body = {
      'otp': otp,
      'sessionId': sessionId
    };

    final response = await http.post(
        Uri.parse(ApiUrl.verifyOTPUrl),
         headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(body));
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }
}