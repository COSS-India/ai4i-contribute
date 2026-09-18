import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:ai4i_contribute/config/app_config.dart';
import 'package:flutter/foundation.dart';

class RecordingService {
  static final RecordingService _instance = RecordingService._internal();
  factory RecordingService() => _instance;
  RecordingService._internal();

  static AppConfig get _config => AppConfig.instance;

  /// Save recording to local storage
  Future<String?> saveRecordingLocally(
    String tempFilePath, {
    required String language,
    required String text,
    required int sentenceId,
  }) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${documentsDir.path}/recordings');

      // Create recordings directory if it doesn't exist
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      // Generate filename with timestamp and language
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'recording_${language}_${sentenceId}_$timestamp.m4a';
      final permanentPath = '${recordingsDir.path}/$filename';

      // Copy from temp to permanent location
      final tempFile = File(tempFilePath);
      await tempFile.copy(permanentPath);

      // Save metadata
      await _saveRecordingMetadata(permanentPath, {
        'language': language,
        'text': text,
        'sentenceId': sentenceId,
        'timestamp': timestamp,
        'filename': filename,
      });

      debugPrint('Recording saved locally: $permanentPath');
      return permanentPath;
    } catch (e) {
      debugPrint('Error saving recording locally: $e');
      return null;
    }
  }

  /// Upload recording to server
  Future<bool> uploadRecordingToServer(
    String filePath, {
    required String language,
    required String text,
    required int sentenceId,
    required String userName,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('Recording file does not exist: $filePath');
        return false;
      }

      // Create multipart request
      final uri = Uri.parse('${_config.apiBaseUrl}/upload-recording');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll(_config.defaultHeaders);

      // Add file
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        filePath,
        filename: path.basename(filePath),
      ));

      // Add form fields
      request.fields.addAll({
        'language': language,
        'text': text,
        'sentenceId': sentenceId.toString(),
        'userName': userName,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Recording uploaded successfully');
        return true;
      } else {
        debugPrint('Upload failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error uploading recording: $e');
      return false;
    }
  }

  /// Save recording metadata to local file
  Future<void> _saveRecordingMetadata(
      String filePath, Map<String, dynamic> metadata) async {
    try {
      final metadataFile = File('$filePath.meta');
      await metadataFile.writeAsString(metadata.toString());
    } catch (e) {
      debugPrint('Error saving metadata: $e');
    }
  }

  /// Load recording metadata
  Future<Map<String, dynamic>?> loadRecordingMetadata(String filePath) async {
    try {
      final metadataFile = File('$filePath.meta');
      if (await metadataFile.exists()) {
        final content = await metadataFile.readAsString();
        // Simple parsing - in production, use proper JSON
        return {'filePath': filePath, 'content': content};
      }
    } catch (e) {
      debugPrint('Error loading metadata: $e');
    }
    return null;
  }

  /// Get all local recordings
  Future<List<Map<String, dynamic>>> getAllLocalRecordings() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${documentsDir.path}/recordings');

      if (!await recordingsDir.exists()) {
        return [];
      }

      final files = await recordingsDir.list().toList();
      final recordings = <Map<String, dynamic>>[];

      for (final file in files) {
        if (file is File && file.path.endsWith('.m4a')) {
          final metadata = await loadRecordingMetadata(file.path);
          if (metadata != null) {
            recordings.add(metadata);
          }
        }
      }

      return recordings;
    } catch (e) {
      debugPrint('Error getting local recordings: $e');
      return [];
    }
  }

  /// Delete local recording
  Future<bool> deleteLocalRecording(String filePath) async {
    try {
      final file = File(filePath);
      final metadataFile = File('$filePath.meta');

      if (await file.exists()) {
        await file.delete();
      }
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting recording: $e');
      return false;
    }
  }

  /// Get recording file size
  Future<int> getRecordingFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
    } catch (e) {
      debugPrint('Error getting file size: $e');
    }
    return 0;
  }

  /// Check if recording exists
  Future<bool> recordingExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      debugPrint('Error checking file existence: $e');
      return false;
    }
  }
}
