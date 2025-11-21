import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:VoiceGive/models/module_status_model.dart';
import 'package:VoiceGive/models/module_sample_model.dart';

class ModuleService {
  static const String baseUrl = 'http://10.0.2.2:9000'; // Use 10.0.2.2 for Android emulator

  static Future<ModuleStatusModel?> getModuleStatus(String module) async {
    try {
      final url = '$baseUrl/$module/status';
      debugPrint('Calling status API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      ).timeout(Duration(seconds: 5));

      debugPrint('Status API response code: ${response.statusCode}');
      debugPrint('Status API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ModuleStatusModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Status API error: $e - Using mock data');
      // Return mock status when API is not available
      return ModuleStatusModel(module: module, status: 'ok');
    }
  }

  static Future<ModuleSampleModel?> getModuleSample(String module) async {
    try {
      final url = '$baseUrl/$module/sample';
      debugPrint('Calling sample API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      ).timeout(Duration(seconds: 5));

      debugPrint('Sample API response code: ${response.statusCode}');
      debugPrint('Sample API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ModuleSampleModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Sample API error: $e - Using mock data');
      // Return mock sample data when API is not available
      return _getMockSampleData(module);
    }
  }

  static ModuleSampleModel _getMockSampleData(String module) {
    return ModuleSampleModel(
      comment: 'Phase 1 mock data for module validation. API server not running - using fallback data.',
      module: module,
      sampleItems: [
        SampleItem(
          id: '${module[0]}1',
          text: '$module sample item 1 (mock data)',
        ),
        SampleItem(
          id: '${module[0]}2',
          text: '$module sample item 2 (mock data)',
        ),
      ],
    );
  }
}