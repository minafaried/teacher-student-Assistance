import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfView extends StatefulWidget {
  final String fileUrl;
  
  PdfView(this.fileUrl,);
  @override
  State<StatefulWidget> createState() {
    return PdfViewState();
  }
}

class PdfViewState extends State<PdfView> {
  bool isloaded = false;
static String pathPDF = "";
  static String pdfUrl = "";
  PDFDocument document;
  void getpdf() async {
    setState(() {
      isloaded = false;
    });
    
    await PDFDocument.fromURL(widget.fileUrl).then((onValue) {
      setState(() {
        document = onValue;

        isloaded = true;
      });

      return;
    });
  }

  @override
  void initState() {
    getpdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isloaded
          ? PDFViewer(document: document)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
