import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/modules/drawer/modules/settings/models/user_settings.dart';
import 'package:ummobile/services/storage/user_settings.dart';
import 'package:ummobile/statics/Widgets/form/bottomsheet/bottomsheet_controller.dart';

class UserSettingsController extends ControllerTemplate {
  late UserSettingsStorage storage;
  late UserSettings userSettings;

  final BottomSheetController themeController = BottomSheetController();
  final BottomSheetController languageController = BottomSheetController();

  @override
  void onInit() {
    _initData();
    super.onInit();
  }

  void _initData() async {
    await _initStorage();
    _checkTheme();
    _checkLocale();
  }

  Future<void> _initStorage() async {
    isLoading(true);
    storage = UserSettingsStorage(await getApplicationDocumentsDirectory());
    userSettings = UserSettings.fromJson(storage.contentCopy);
    isLoading(false);
  }

  void _checkTheme() {
    themeController.id = userSettings.themeMode.index;
  }

  void _checkLocale() {
    if (userSettings.language != null) {
      if (userSettings.language == Locale('es', 'MX')) {
        languageController.id = 1;
      } else {
        languageController.id = 2;
      }
    } else {
      languageController.id = 0;
    }
  }
}
