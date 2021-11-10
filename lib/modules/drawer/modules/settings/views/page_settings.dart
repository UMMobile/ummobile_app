import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/settings/controllers/user_settings.dart';
import 'package:ummobile/modules/drawer/modules/settings/models/user_settings.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/Widgets/form/bottomsheet/botomsheet.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UmAppBar(
        title: 'settings'.tr,
        showActionIcons: false,
      ),
      body: GetX<UserSettingsController>(
        init: UserSettingsController(),
        builder: (_) {
          if (_.isLoading.value)
            return Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('select'.trParams({
                  'element': 'theme'.tr,
                })),
                BottomSheetButton(
                  children: ["system".tr, "light".tr, "dark".tr],
                  hint: 'select'.trParams({
                    'element': 'theme'.tr,
                  }),
                  onSelect: (index) {
                    ThemeMode theme;
                    switch (index) {
                      case 1:
                        theme = ThemeMode.light;
                        break;
                      case 2:
                        theme = ThemeMode.dark;
                        break;
                      default:
                        theme = ThemeMode.system;
                    }

                    Get.changeThemeMode(theme);
                    _.userSettings.themeMode = theme;
                    _.storage.write(_.userSettings.toJson());
                  },
                  controller: _.themeController,
                ),
                SizedBox(height: 10),
                Text('select'.trParams({
                  'element': 'language'.tr,
                })),
                BottomSheetButton(
                  children: ["system".tr, "spanish".tr, "english".tr],
                  hint: 'select'.trParams({
                    'element': 'language'.tr,
                  }),
                  onSelect: (index) {
                    Locale? language;
                    if (index == 0) {
                      language = null;
                      Get.updateLocale(Get.deviceLocale!);
                    } else {
                      language = UserSettings.supportedLocales[index - 1];
                      Get.updateLocale(language);
                    }

                    _.userSettings.language = language;
                    _.storage.write(_.userSettings.toJson());
                  },
                  controller: _.languageController,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
