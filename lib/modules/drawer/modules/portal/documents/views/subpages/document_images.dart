import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/portal/documents/controllers/document_images_controller.dart';

class DocumentImages extends StatefulWidget {
  /// The document Name
  final String documentName;

  DocumentImages({required this.documentName});

  @override
  State<DocumentImages> createState() => _DocumentImagesState();
}

class _DocumentImagesState extends State<DocumentImages> {
  final controller = Get.find<DocumentImagesController>();

  @override
  void dispose() {
    Get.delete<DocumentImagesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.documentName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: controller.obx(
        (images) => ListView(
          padding: const EdgeInsets.all(20),
          children: images!
              .map(
                (image) => InteractiveViewer(
                  clipBehavior: Clip.none,
                  child: Image.memory(base64Decode(image.base64Image!)),
                ),
              )
              .toList(),
        ),
        onEmpty: Center(
          child: Text(
            "No existen imágenes para este documento",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
