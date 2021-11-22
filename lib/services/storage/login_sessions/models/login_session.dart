import 'package:hive/hive.dart';

part 'login_session.g.dart';

@HiveType(typeId: 0)
class LoginSession extends HiveObject {
  /// The user's id registered in the academic registry
  @HiveField(0)
  String userId;

  /// The user name
  @HiveField(1)
  final String name;

  /// The user image
  ///
  /// Note: the value is in base64 String
  @HiveField(2)
  final String? image;

  /// The api tokens
  @HiveField(3)
  String authCredentials;

  /// True if this user was the last user logged session
  @HiveField(4)
  bool activeLogin;

  LoginSession({
    required this.userId,
    required this.name,
    this.image,
    this.activeLogin = true,
    required this.authCredentials,
  });

  LoginSession.empty()
      : this.userId = '',
        this.name = '',
        this.image = '',
        this.authCredentials = '',
        this.activeLogin = true;
}
