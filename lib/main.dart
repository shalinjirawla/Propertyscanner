import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/utils/strings.dart';
import 'package:property_scan_pro/utils/theme/app_theme.dart';
import 'package:property_scan_pro/utils/themes.dart';
import 'package:sizer/sizer.dart';

import 'Environment/core/core_config.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config.appEnvironment = Environment.test;
  await ConfigApp.initApp();

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };
  runApp(const PropertyScanApp());
}

class PropertyScanApp extends StatefulWidget {
  const PropertyScanApp({super.key});

  @override
  State<PropertyScanApp> createState() => _PropertyScanAppState();
}

class _PropertyScanAppState extends State<PropertyScanApp> {
  @override
  Widget build(BuildContext context) {
    ConfigApp.disableRotation();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: AppTheme.darkTheme,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200),
            themeMode: ThemeMode.light,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            //disable phone big text size
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

/*
<key>NSCameraUsageDescription</key>
    <string>Scan your card to add it automatically</string>
    <key>NSCameraUsageDescription</key>
    <string>To scan cards</string>
* * */
