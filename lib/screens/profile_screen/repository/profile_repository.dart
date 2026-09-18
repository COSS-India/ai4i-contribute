import 'package:ai4i_contribute/screens/profile_screen/service/profile_service.dart';
import 'package:flutter/material.dart';

import '../model/age_group_model.dart';
import '../model/country_model.dart';
import '../model/district_model.dart';
import '../model/gender_model.dart';
import '../model/language_model.dart';
import '../model/state_model.dart';
import '../model/user_model.dart';

class ProfileRepository {
  Future<dynamic> registration(
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
    try {
      var response = await ProfileService.registration(
          firstName: firstName,
          lastName: lastName,
          ageGroup: ageGroup,
          gender: gender,
          mobileNo: mobileNo,
          email: email,
          country: country,
          state: state,
          district: district,
          preferredLanguage: preferredLanguage);
      if (response['data'] == null) {
        return response['detail'] != null && response['detail'].isNotEmpty
            ? response['detail'].first['msg']
            : 'Error occurred during registration';
      }
      return UserModel.fromJson(response['data']);
    } catch (e) {
      debugPrint(e.toString());
      return 'Error occurred during registration';
    }
  }

  Future<List<AgeModel>> getAgeGroup() async {
    try {
      var response = await ProfileService.getAgeGroup();
      if (response['data'] == null) {
        return [];
      }
      List<AgeModel> ageList =
          (response['data'] as List).map((e) => AgeModel.fromJson(e)).toList();
      return ageList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<GenderModel>> getGender() async {
    try {
      var response = await ProfileService.getGender();
      if (response['data'] == null) {
        return [];
      }
      List<GenderModel> genderList = (response['data'] as List)
          .map((e) => GenderModel.fromJson(e))
          .toList();
      return genderList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<CountryModel>> getCountries() async {
    try {
      var response = await ProfileService.getCountries();
      if (response['data'] == null) {
        return [];
      }
      List<CountryModel> countryList = (response['data'] as List)
          .map((e) => CountryModel.fromJson(e))
          .toList();
      return countryList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<StateModel>> getState(String countryId) async {
    try {
      var response = await ProfileService.getState(countryId);
      if (response['data'] == null && response['data']['states']) {
        return [];
      }
      List<StateModel> stateList = (response['data']['states'] as List)
          .map((e) => StateModel.fromJson(e))
          .toList();
      return stateList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<DistrictModel>> getDistrict(String stateId) async {
    try {
      var response = await ProfileService.getDistrict(stateId);
      if (response['data'] == null) {
        return [];
      }
      List<DistrictModel> districtList = (response['data']['districts'] as List)
          .map((e) => DistrictModel.fromJson(e))
          .toList();
      return districtList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<LanguageModel>> getLanguages() async {
    try {
      var response = await ProfileService.getLanguages();
      if (response['data'] == null) {
        return [];
      }
      List<LanguageModel> languageList = (response['data'] as List)
          .map((e) => LanguageModel.fromJson(e))
          .toList();
      return languageList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
