import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String subject;
  final String dateText;
  final String timeDetails;
  final Color? headerColor;
  final String? description;

  const AppointmentDetailsPage({
    Key? key,
    required this.subject,
    required this.dateText,
    required this.timeDetails,
    this.headerColor,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: "details".trParams({'element': "event".tr}).capitalizeFirst!,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: headerColor ?? Get.theme.colorScheme.secondary,
            expandedHeight: 200,
            floating: false,
            pinned: true,
            stretch: true,
            leading: Container(),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Text(
                  subject,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.event, size: 54),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateText, style: Get.textTheme.subtitle1),
                        Text(
                          "date".tr.capitalizeFirst!,
                          style: Get.textTheme.subtitle2!
                              .copyWith(color: Get.theme.hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 54),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(timeDetails, style: Get.textTheme.subtitle1),
                        Text(
                          "hour".tr.capitalizeFirst!,
                          style: Get.textTheme.subtitle2!
                              .copyWith(color: Get.theme.hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (description != null) Text(description!),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
