class PreferenceInfoModel {
  PreferenceInfoModel({
    this.token,
    this.tokenRefresh,
    this.fcmToken,
    this.username,
    this.password,
    this.fullName,
  });

  PreferenceInfoModel.fromJson(dynamic json) {
    token = json['token'];
    tokenRefresh = json['tokenRefresh'];
    fcmToken = json['fcmToken'];
    username = json['username'];
    password = json['password'];
    fullName = json['fullName'];
  }

  String? token;
  String? tokenRefresh;
  String? fcmToken;
  String? username;
  String? password;
  String? fullName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['tokenRefresh'] = tokenRefresh;
    map['fcmToken'] = fcmToken;
    map['username'] = username;
    map['password'] = password;
    map['fullName'] = fullName;
    return map;
  }
}
