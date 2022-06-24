import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullScreen extends StatefulWidget {
  String url, extention;

  FullScreen({required this.url, required this.extention});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.extention != "pdf"
            ? Center(
                child: Container(
                    height: 100.h,
                    width: 100.w,
                    child: Image.network(widget.url)),
              )
            : SfPdfViewer.network(widget.url),
      ),
    );
  }
}
