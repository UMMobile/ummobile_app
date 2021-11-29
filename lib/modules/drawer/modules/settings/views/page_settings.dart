import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/drawer/modules/settings/controllers/app_settings_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/services/storage/app_settings/models/app_settings.dart';
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
      body: GetX<AppSettingsController>(
        init: AppSettingsController(),
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
                    _.appSettings.themeMode = theme;
                    _.storage.saveSettings(_.appSettings);
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
                      language = AppSettings.supportedLocales[index - 1];
                      Get.updateLocale(language);
                    }

                    _.appSettings.language = language;
                    _.storage.saveSettings(_.appSettings);
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
