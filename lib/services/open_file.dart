import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

Future<void> openWordFileFromAssets(String assetPath, String fileName) async {
  try {
    // Load the file from assets
    final byteData = await rootBundle.load(assetPath);

    // Get a writable directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');

    // Write the file
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // Open it using the default app
    final uri = Uri.file(file.path);
    print('Word file saved at: ${file.path}');
    await launchUrl(uri);
  } catch (e) {
    print('Error opening file: $e');
  }
}
