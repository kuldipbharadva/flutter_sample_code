class LoginResponse {
  LoginResponse({
    this.token,
    this.tokenRefresh,
    this.tokenExpiryDate,
    this.tokenExpiryTime,
    this.fullNameAr,
    this.fullNameEn,
    this.userFunctions,
  });

  LoginResponse.fromJson(dynamic json) {
    token = json['token'];
    tokenRefresh = json['tokenRefresh'];
    tokenExpiryDate = json['tokenExpiryDate'];
    tokenExpiryTime = json['tokenExpiryTime'];
    fullNameAr = json['fullNameAr'];
    fullNameEn = json['fullNameEn'];
    userFunctions = json['userFunctions'] != null
        ? json['userFunctions'].cast<String>()
        : [];
  }

  String? token;
  String? tokenRefresh;
  String? tokenExpiryDate;
  String? tokenExpiryTime;
  String? fullNameAr;
  dynamic fullNameEn;
  List<String>? userFunctions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['tokenRefresh'] = tokenRefresh;
    map['tokenExpiryDate'] = tokenExpiryDate;
    map['tokenExpiryTime'] = tokenExpiryTime;
    map['fullNameAr'] = fullNameAr;
    map['fullNameEn'] = fullNameEn;
    map['userFunctions'] = userFunctions;
    return map;
  }
}
