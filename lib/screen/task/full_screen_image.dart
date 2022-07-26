import 'package:constructin/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/app_asset.dart';
import '../../utils/app_color.dart';
import '../../widget/comman_widget.dart';

class FullScreen extends StatefulWidget {
  String url, extention;
  String? delete;

  FullScreen({required this.url, required this.extention, this.delete});

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
          Container(
            height: 15.w,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: AppColor.bg,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 5.w, top: 3.w, bottom: 3.w, right: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, 1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                          height: 5.w,
                          width: 7.w,
                          child: Image.asset(ImageAsset.arrow_back)),
                    ),
                  ),
                  widget.delete == "delete"
                      ? InkWell(
                          onTap: () {
                            showMyDialog(
                                context, "are you sure, delete this image?",
                                () {
                              Navigator.pop(context);
                              Navigator.pop(context, 2);
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            size: 8.w,
                            color: AppColor.black,
                          ))
                      : Container()
                ],
              ),
            ),
          ),
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
