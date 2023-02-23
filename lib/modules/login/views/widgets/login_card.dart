import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/route_manager.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/controllers/questionnaire_response_controller.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/modules/login/views/widgets/renew_login.dart';
import 'package:ummobile/statics/settings/colors.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';

/// Card that displays basic user identify data and logins to that user on click
class LoginSessionCard extends StatelessWidget {
  /// The index of the user in the list
  final int userIndex;

  /// The id of the user in the academic registry
  final String userId;

  /// The api tokens
  final String credentials;

  /// The user name
  final String name;

  /// The user image
  final String? image;

  const LoginSessionCard({
    Key? key,
    required this.userIndex,
    required this.userId,
    required this.credentials,
    required this.name,
    this.image,
  }) : super(key: key);

  //bool _loaded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: () async {
          bool canEnterDirectly =
              await Get.find<LoginController>().checkOrRenewCredentials(
            userId: userId,
            jsonCredentials: credentials,
          );

          if (canEnterDirectly) {
            loginTransition();
          } else {
            Get.to(
              () => RenewLogin(
                index: this.userIndex,
                userId: this.userId,
                image: this.image,
              ),
              fullscreenDialog: false,
              opaque: false,
              transition: Transition.fadeIn,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(128, 132),
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
          foregroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 2,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User Image display
                Hero(
                  tag: userId,
                  child: Container(
                    height: 110,
                    width: 134,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (image != null && image!.isNotEmpty)
                            ? MemoryImage(base64Decode(image!))
                            : AssetImage('assets/img/default-img.jpg')
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),

                // User Credential text
                Text(
                  userId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColorThemes.textColor,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -20,
              right: -20,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                  size: 26,
                ),
                onPressed: () => openDialogWindow(
                  title: 'delete_dialog_title'.trParams({'element': 'user'.tr}),
                  message: 'delete_dialog_message'.tr,
                  onCancel: () => Get.back(),
                  onConfirm: () async {
                    openLoadingDialog(
                        'deleting'.trParams({'element': 'user'.tr}));
                    Get.find<LoginController>().removeUser(userIndex);
                    Get.find<QuestionnaireResponseController>()
                        .refreshContent();
                    Get.back();
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
