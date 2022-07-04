import 'package:constructin/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../widget/comman_widget.dart';

class FullScreen extends StatefulWidget {
  String url, extention;

  FullScreen({required this.url, required this.extention});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  void initState() {
    print("AppString.basePath ${AppString.basePath}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          appBar("", () {
            Get.back();
          }),
          widget.extention != "pdf"
              ? Expanded(
                  child: Center(
                      child: PhotoView(
                    imageProvider:
                        NetworkImage(AppString.basePath + widget.url),
                  )),
                )
              : Expanded(
                  child: SfPdfViewer.network(AppString.basePath + widget.url)),
        ],
      )),
    );
  }
}
