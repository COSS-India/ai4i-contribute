import 'dart:io';

void main() async {
  try {
    // Check for existing font files
    final fontsDir = Directory('assets/fonts');
    final existingFonts = <String>[];
    
    if (fontsDir.existsSync()) {
      final files = fontsDir.listSync();
      for (final file in files) {
        if (file is File && (file.path.endsWith('.ttf') || file.path.endsWith('.otf'))) {
          existingFonts.add(file.path.replaceAll('\\', '/'));
        }
      }
    }

    // Read current pubspec.yaml
    final pubspecFile = File('pubspec.yaml');
    final lines = await pubspecFile.readAsLines();
    
    // Find and remove existing font section
    int startIndex = -1;
    int endIndex = -1;
    
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('# Custom fonts') || lines[i].contains('# No custom fonts')) {
        startIndex = i;
      }
      if (startIndex != -1 && lines[i].contains('flutter_icons:')) {
        endIndex = i;
        break;
      }
    }
    
    // Remove old font section
    if (startIndex != -1 && endIndex != -1) {
      lines.removeRange(startIndex, endIndex);
    }
    
    // Add new font section
    final insertIndex = lines.indexWhere((line) => line.contains('flutter_icons:'));
    if (insertIndex != -1) {
      if (existingFonts.isNotEmpty) {
        lines.insert(insertIndex, '  # Custom fonts loaded dynamically');
        lines.insert(insertIndex + 1, '  fonts:');
        
        for (int i = 0; i < existingFonts.length; i++) {
          final fontPath = existingFonts[i];
          String fontFamily;
          if (i == 0) fontFamily = 'CustomPrimary';
          else if (i == 1) fontFamily = 'CustomSecondary';
          else fontFamily = 'CustomTertiary';
          
          lines.insert(insertIndex + 2 + (i * 3), '    - family: $fontFamily');
          lines.insert(insertIndex + 3 + (i * 3), '      fonts:');
          lines.insert(insertIndex + 4 + (i * 3), '        - asset: $fontPath');
        }
        lines.insert(insertIndex + 2 + (existingFonts.length * 3), '');
      } else {
        lines.insert(insertIndex, '  # No custom fonts - using Google Fonts');
        lines.insert(insertIndex + 1, '');
      }
    }
    
    await pubspecFile.writeAsString(lines.join('\n'));
    print('Font configuration updated: ${existingFonts.length} fonts found');
    
  } catch (e) {
    print('Error updating font configuration: $e');
  }
}