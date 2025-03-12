import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttersampleapp/core/dependency/global_get_it.dart';
import 'package:fluttersampleapp/core/model/preference_info_model.dart';
import 'package:fluttersampleapp/core/push_notification/push_notification_helper.dart';
import 'package:fluttersampleapp/core/routes/app_router.dart';
import 'package:fluttersampleapp/core/storage/i_preference.dart';
import 'package:fluttersampleapp/core/storage/preference_keys.dart';
import 'package:fluttersampleapp/core/utils/app_colors.dart';
import 'package:fluttersampleapp/features/authentication/dependency/auth_get_it.dart';

final AppRouter appRouterGlobal = AppRouter();
PreferenceInfoModel preferenceInfoModel = PreferenceInfoModel();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeGetIt();
  await PushNotificationHelper.configurePush();
  await _loadPreferenceValue();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: colorStatusBar,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp.router(
        title: 'Flutter Simple App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: fontFamilyRegular,
          primaryColor: Colors.white,
          colorScheme: const ColorScheme.light(surface: Colors.white),
          useMaterial3: true,
        ),
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale('ar', 'AE'),
        //   // English, no country code
        // ],
        routerConfig: appRouterGlobal.config(),
      ),
    );
  }
}

_loadPreferenceValue() async {
  String token = await globalGetIt<IPreference>().getPreferenceValue(
      preferenceKey: PreferenceKey.prefToken, defaultValue: '');
  String fcmToken = await globalGetIt<IPreference>().getPreferenceValue(
      preferenceKey: PreferenceKey.prefFcmToken, defaultValue: '');
  String username = await globalGetIt<IPreference>().getPreferenceValue(
      preferenceKey: PreferenceKey.prefUsername, defaultValue: '');
  String password = await globalGetIt<IPreference>().getPreferenceValue(
      preferenceKey: PreferenceKey.prefPassword, defaultValue: '');
  String fullName = await globalGetIt<IPreference>().getPreferenceValue(
      preferenceKey: PreferenceKey.prefFullName, defaultValue: '');
  preferenceInfoModel.token = token;
  preferenceInfoModel.fcmToken = fcmToken;
  preferenceInfoModel.username = username;
  preferenceInfoModel.password = password;
  preferenceInfoModel.fullName = fullName;
}

Future<void> initializeGetIt() async {
  await setupGlobalGetIt();
  await setupAuthGetIt();
}
