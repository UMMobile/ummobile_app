/*import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';*/
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/services/storage/user_settings.dart';
import 'package:ummobile/services/translations/get_translations.dart';
import 'package:ummobile/services/translations/translations_initialize.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'modules/drawer/modules/settings/models/user_settings.dart';
import 'modules/login/views/page_login.dart';
import 'services/onesignal/handle_events.dart';
import 'services/onesignal/operations.dart';
import 'statics/settings/colors.dart';

UserSettings? _userSettings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterTranslations.initialize();
  _userSettings = UserSettings.fromJson(
      UserSettingsStorage(await getApplicationDocumentsDirectory())
          .contentCopy);
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
    handleOneSignalEvents();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UM Mobile',

      smartManagement: SmartManagement.onlyBuilder,

      /// Theme section
      theme: AppColorThemes.brightTeme,
      darkTheme: AppColorThemes.darkTheme,
      themeMode: _userSettings!.themeMode,

      /// Internationalization section
      translations: Messages(),
      supportedLocales: [Locale('en'), Locale('es', 'MX')],
      fallbackLocale: Locale('es', 'MX'),
      locale: _userSettings!.language ??
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


