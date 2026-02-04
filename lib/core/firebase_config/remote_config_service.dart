import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  late FirebaseRemoteConfig remoteConfig;

  Future<void> initialize() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );

    await remoteConfig.fetchAndActivate();
  }

  dynamic get envVar => json.decode(remoteConfig.getString('env_vars'));
}

/**
    => To create config file in firebase you have to create project on firebase console and you have
    to platform specific module, then in sidebar menu option Run > goto remote config > create

    => You can read config value as per below use, and you can manage config file variables
    according to requirements, check main.dart for initialization

    var envVar = RemoteConfigService().envVar;
    logcat('env var = ${envVar['isStage']}');
 * */
