import 'package:flutter/material.dart';
import 'package:ummobile/services/storage/app_settings/models/app_settings.dart';
import 'package:ummobile/services/storage/app_settings/settings_box.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/statics/Widgets/form/bottomsheet/bottomsheet_controller.dart';

class AppSettingsController extends ControllerTemplate {
  late AppSettingsBox storage = AppSettingsBox();
  late AppSettings appSettings;

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
    await storage.initializeBox();
    appSettings = storage.appSettings;
    isLoading(false);
  }

  void _checkTheme() {
    themeController.id = appSettings.themeMode.index;
  }

  void _checkLocale() {
    if (appSettings.language != null) {
      if (appSettings.language == Locale('es', 'MX')) {
        languageController.id = 1;
      } else {
        languageController.id = 2;
      }
    } else {
      languageController.id = 0;
    }
  }
}
