import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show Rect, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> generatePdfWithTemplate({
  required String name,
  required String phone,
}) async {
  // Load PDF template
  final data = await rootBundle.load('assets/pg.pdf');
  final document = PdfDocument(inputBytes: data.buffer.asUint8List());
  // Draw text at specific positions (X, Y) on page 1
  final page = document.pages[0];
  page.graphics.drawString(
    ' $name',
    PdfStandardFont(PdfFontFamily.courier, 12),
    bounds: const Rect.fromLTWH(100, 100, 300, 20),
  );
  page.graphics.drawString(
    ' $phone',
    PdfStandardFont(PdfFontFamily.courier, 12),
    bounds: const Rect.fromLTWH(100, 130, 300, 20),
  );

  // Save the new file
  final dir = await getApplicationDocumentsDirectory();
  final bytes = await document.save(); // wait for the bytes to be ready
  final file = File('${dir.path}/conge_$name.pdf');
  await file.writeAsBytes(bytes);
  document.dispose();

  print('✅ PDF généré: ${file.path}');
}
