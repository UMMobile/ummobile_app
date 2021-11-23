import 'package:hive/hive.dart';
import 'package:ummobile/services/storage/app_settings/models/app_settings.dart';

/// Stores the user's settings into a json file
///
/// Creates a json file if not exists in device
class AppSettingsBox {
  /// The box key
  final String _boxId = "settings";

  final String _themeKey = "theme";
  final String _languageKey = "language";

  /// Initializes the box for read/write functions
  Future<Box> initializeBox() async {
    return await Hive.openBox(this._boxId);
  }

  Box get box => Hive.box(this._boxId);

  /// Closes the box to free memory
  void closeBox() async {
    await Hive.box(this._boxId).close();
  }

  /// Returns the app settings from storage
  AppSettings get appSettings => AppSettings.fromStorage(
        this.box.get(_themeKey),
        this.box.get(_languageKey),
      );

  /// Saves the app settings in storage
  ///
  /// True if the operation completes succesfully
  bool saveSettings(AppSettings newSettings) {
    this.box.put(
          _themeKey,
          AppSettings.themeModeToString(newSettings.themeMode),
        );

    if (newSettings.language != null)
      this.box.put(
            _languageKey,
            AppSettings.supportedLocales.indexOf(newSettings.language!),
          );
    else
      this.box.put(
            _languageKey,
            null,
          );
    return true;
  }
}
