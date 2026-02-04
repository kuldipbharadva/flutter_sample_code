import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference_keys.dart';
import 'package:fluttersampleapp/core/utils/common_functions.dart';
import 'package:fluttersampleapp/main.dart';

class PushNotificationHelper {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Random random = Random();

  static Future<void> configurePush() async {
    _requestAndGetToken();
    _attachListeners();
    _initLocalNotification();
  }

  static void _requestAndGetToken() {
    FirebaseMessaging.instance
      ..requestPermission()
      ..getToken().then((value) async {
        logcat('fcm token == $value');
        await globalGetIt<IPreference>().setPreferenceValue(
          preferenceKey: PreferenceKey.prefFcmToken,
          value: value ?? '',
        );
        preferenceInfoModel.fcmToken = value ?? '';
      })
      ..onTokenRefresh.listen((event) async {
        logcat('firebase token refresh = $event');
        await globalGetIt<IPreference>().setPreferenceValue(
          preferenceKey: PreferenceKey.prefFcmToken,
          value: event,
        );
        preferenceInfoModel.fcmToken = event;
      });
  }

  static void _attachListeners() {
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onMyBackground);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
    FirebaseMessaging.instance.getInitialMessage().then(_onLaunch);
  }

  static Future<void> _onLaunch(RemoteMessage? message) async {
    logcat(
      'fcm notification _onLaunch notification :: ${message?.notification}',
    );
    logcat('fcm notification _onLaunch data :: ${message?.data}');
  }

  static Future<void> _onResume(RemoteMessage message) async {
    logcat('fcm notification _onResume data :: ${message.data}');
    logcat(
      'fcm notification _onResume notification :: ${message.notification}',
    );
    if (message.notification != null) _navigateScreen();
  }

  /// Handle in app notification
  static Future<void> _onMessage(RemoteMessage message) async {
    logcat('fcm notification _onMessage data :: ${message.data}');
    logcat(
      'fcm notification _onMessage notification :: ${message.notification}',
    );
    if (Platform.isAndroid) {
      _showLocalNotification(message);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onMyBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    logcat('fcm notification _onMyBackground data :: ${message.data}');
    logcat(
      'fcm notification _onMyBackground notification :: ${message.notification}',
    );
    // if (Platform.isAndroid) {
    //   _showLocalNotification(message);
    // }
  }

  static void _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    var iosSetup = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = Platform.isIOS
        ? InitializationSettings(iOS: iosSetup)
        : const InitializationSettings(android: initializationSettingsAndroid);

    /// didReceived called when app open or in background and tap on received notification
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            logcat(
              'fcm notification onDidReceiveNotificationResponse notification payload == ${notificationResponse.payload}',
            );
            _onDidReceiveLocalNotification(notificationResponse.payload);
          },
    );

    /// below code/method called when app terminated and launched, you will get payload when terminated app launched on tap of notification
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((
      value,
    ) {
      logcat(
        'fcm notification getNotificationAppLaunchDetails notification payload == ${value?.notificationResponse?.payload}',
      );
      if (value?.notificationResponse?.payload != null) {
        _navigateScreen();
      }
    });

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'DigitalJepco_Notification_High',
      'Digital Jepco',
      description: 'Digital Jepco Service Notification',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future _onDidReceiveLocalNotification(String? payload) async {
    _navigateScreen();
  }

  static void _navigateScreen() async {
    // String id = await globalGetIt.get<IPreference>().getPreferenceValue(
    //     preferenceKey: PreferenceKey.currentUser, defaultValue: '');
    // logcat('notification preference user id = $id');
    //
    // if (id.isNotEmpty) {
    //   appRouterGlobal.replaceAll([const HomeRoute(), const HistoryRoute()]);
    // }
  }

  /// this function will show notification
  static void _showLocalNotification(RemoteMessage? map) async {
    if (map == null) return;
    logcat(
      'fcm notification _showLocalNotification notification = ${map.notification}',
    );
    logcat('fcm notification _showLocalNotification data = ${map.data}');

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'DigitalJepco_Notification_High',
          'Digital Jepco',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    var title = map.notification?.title ?? map.data['title'];

    final body = map.notification?.body ?? map.data['body'];

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(map.data),
    );
  }
}
