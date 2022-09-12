/*import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';*/
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ummobile/modules/app_bar/modules/notifications/controllers/notifications_controller.dart';
import 'package:ummobile/services/storage/app_settings/models/app_settings.dart';
import 'package:ummobile/services/storage/app_settings/settings_box.dart';
import 'package:ummobile/services/storage/storage_registry.dart';
import 'package:ummobile/services/translations/get_translations.dart';
import 'package:ummobile/services/translations/translations_initialize.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'modules/login/views/page_login.dart';
import 'services/onesignal/operations.dart';
import 'statics/settings/colors.dart';

AppSettings? _appSettings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Hive.initFlutter();
  await FlutterTranslations.initialize();
  RegisterHiveAdapters();

  final appSettingsBox = AppSettingsBox();
  await appSettingsBox.initializeBox();
  _appSettings = appSettingsBox.appSettings;
  runApp(
    /*DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
*/
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initializeOneSignal();
    handleOneSignalEvents(
      onReceive: (notification) {
        bool notificationsControllerExist =
            Get.isRegistered<NotificationsController>();

        if (notificationsControllerExist) {
          Get.find<NotificationsController>().add(notification.notificationId);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UM Mobile',

      smartManagement: SmartManagement.onlyBuilder,

      /// Theme section
      theme: AppColorThemes.brightTeme,
      darkTheme: AppColorThemes.darkTheme,
      themeMode: _appSettings?.themeMode ?? ThemeMode.system,

      /// Internationalization section
      translations: Messages(),
      supportedLocales: [Locale('en'), Locale('es', 'MX')],
      fallbackLocale: Locale('es', 'MX'),
      locale: _appSettings?.language ??
          Get.deviceLocale, //DevicePreview.locale(context),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],

      /// Util section
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        Intl.defaultLocale = Localizations.localeOf(context).languageCode;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
          child: child!,
        );
      },
      //builder: DevicePreview.appBuilder,

      home: LoginPage(),
    );
  }
}

//! TODO: Delete Device simulator lines before publishing app


