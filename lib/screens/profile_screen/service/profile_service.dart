import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../constants/api_url.dart';

class ProfileService {
  static Future<dynamic> registration(
      {required String firstName,
      required String lastName,
      required String ageGroup,
      required String gender,
      required String mobileNo,
      String? email,
      required String country,
      required String state,
      required String district,
      String? preferredLanguage}) async {
    Map body = {
      'firstName': firstName,
      'lastName': lastName,
      'ageGroup': ageGroup,
      'gender': gender,
      'mobileNo': mobileNo,
      'email': email,
      'country': country,
      'state': state,
      'district': district,
      'preferredLanguage': preferredLanguage
    };

    final response = await http.post(Uri.parse(ApiUrl.userRegisterUrl),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: json.encode(body));
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getAgeGroup() async {
    final response = await http.get(
      Uri.parse(ApiUrl.ageGroupUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getGender() async {
    final response = await http.get(
      Uri.parse(ApiUrl.genderUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getCountries() async {
    final response = await http.get(
      Uri.parse(ApiUrl.countryUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getState(String countryId) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.stateUrl}$countryId'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getDistrict(String stateId) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.districtUrl}$stateId'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }

  static Future<dynamic> getLanguages() async {
    final response = await http.get(
      Uri.parse(ApiUrl.languageUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
    );
    Map convertedResponse = json.decode(response.body);

    return convertedResponse;
  }
}
