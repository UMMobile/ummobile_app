import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/services/authentication/auth.dart';

class RenewLogin extends StatefulWidget {
  final int index;
  final String credential;
  final String? image;
  RenewLogin({
    Key? key,
    required this.index,
    required this.credential,
    this.image,
  }) : super(key: key);

  @override
  _RenewLoginState createState() => _RenewLoginState();
}

class _RenewLoginState extends State<RenewLogin> {
  late TextEditingController _passwordController;

  late Uint8List? _convertedImage;
  bool _showPassword = false;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _convertedImage = (widget.image != null && widget.image!.isNotEmpty)
        ? base64Decode(widget.image!)
        : null;
    super.initState();
  }

  _submitForm(BuildContext context) {
    String userId = widget.credential;
    if (fieldAreValid(userId, _passwordController.text)) {
      loginCredentials(userId, _passwordController.text).then((credential) {
        Get.find<LoginController>().renewUser(widget.index, credential);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.zero,
              width: 24,
              height: 24,
              //decoration: BoxDecoration(border: Border.all(width: 1)),
              child: TextButton(
                child: Icon(Icons.arrow_back),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  primary: Get.theme.primaryColor,
                  shape: CircleBorder(),
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Hero(
            tag: widget.credential,
            child: Container(
              width: 180,
              height: 120,
              child: Image(
                image: (_convertedImage != null)
                    ? MemoryImage(_convertedImage!)
                    : AssetImage('assets/img/default-img.jpg')
                        as ImageProvider<Object>,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(widget.credential,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextField(
            cursorColor: Theme.of(context).colorScheme.secondary,
            controller: _passwordController,
            obscureText: !_showPassword,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            decoration: InputDecoration(
                hintText: 'password'.tr.capitalizeFirst!,
                hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5)),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.secondary),
                )),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              _submitForm(context);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(170.0, 35.0),
                primary: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1.2,
                    style: BorderStyle.solid),
              ),
              onPressed: () {
                _submitForm(context); //Linea para saltar el login
              },
              child: Text(
                'access'.tr.capitalizeFirst!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
