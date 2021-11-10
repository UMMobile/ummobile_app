import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/internet/models/internet_enum_errors.dart';

class ContentNoInternet extends StatefulWidget {
  final Function toPageReturn;
  final InternetErrorType errorType;
  ContentNoInternet({
    Key? key,
    required this.toPageReturn,
    this.errorType = InternetErrorType.client,
  }) : super(key: key);

  @override
  State<ContentNoInternet> createState() => _ContentNoInternetState();
}

class _ContentNoInternetState extends State<ContentNoInternet> {
  late String imagePath;

  late String titleText;

  late String bodyText;

  @override
  void initState() {
    super.initState();
    switch (widget.errorType) {
      case InternetErrorType.client:
        imagePath = "assets/img/no_internet.svg";
        titleText = "user_disconnection_title".tr;
        bodyText = "user_disconnection_subtitle".tr;
        break;
      case InternetErrorType.server:
        imagePath = "assets/img/no_server.svg";
        titleText = "server_disconnection_title".tr;
        bodyText = "server_disconnection_subtitle".tr;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 25),
          child: SvgPicture.asset(
            imagePath,
            width: 120,
            height: 120,
            semanticsLabel: "sin internet",
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 25, left: 25, right: 25),
          child: Text(
            titleText,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Text(
            bodyText,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 5.0, onPrimary: Colors.white),
            child: Text('reload'.tr.capitalizeFirst!),
            onPressed: () {
              widget.toPageReturn();
            })
      ],
    ));
  }
}
