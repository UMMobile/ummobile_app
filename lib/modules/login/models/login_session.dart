import 'dart:convert';

class LoginSession {
  // TODO (@jonathangomz): [Proposal] Rename credential to userId.
  final String credential;
  final String name;
  final String? image;
  String authCredentials;
  bool activeLogin;

  LoginSession({
    required this.credential,
    required this.name,
    this.image,
    this.activeLogin = true,
    required this.authCredentials,
  });

  LoginSession.empty()
      : this.credential = '',
        this.name = '',
        this.image = '',
        this.authCredentials = '',
        this.activeLogin = true;

  static List<LoginSession> usersFromMap(String str) => List<LoginSession>.from(
      json.decode(str).map((x) => LoginSession.fromMap(x)));

  static String usersToMap(List<LoginSession> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

  factory LoginSession.fromMap(Map<String, dynamic> json) {
    return LoginSession(
      credential: json['credential'] ?? "",
      name: json['name'] ?? "no name",
      image: json['image'] ?? "",
      activeLogin: json['activeLogin'],
      authCredentials: json['authCredentials'] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "credential": credential,
        "name": name,
        "image": image,
        "activeLogin": activeLogin,
        "authCredentials": authCredentials
      };
}
