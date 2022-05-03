import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class pdfWrapper {
  const pdfWrapper(this.pdf);

  final pw.Document pdf;
}

pdfWrapper createPdf(List<String> _images) {
  final pdf = pw.Document();

  for (var imagePath in _images) {
    final image = pw.MemoryImage(
      File(imagePath).readAsBytesSync(),
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20), // in millimeters probably
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        }));
  }

  return pdfWrapper(pdf);
}

Future<void> savePdf(File newDocumentFile, pdfWrapper documentFile) async {
  await newDocumentFile.writeAsBytes(await documentFile.pdf.save());
}