import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'config.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: fontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  dialogBackgroundColor: white,
  dividerColor: black,
  scaffoldBackgroundColor: scaffoldColor,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  useMaterial3: true,
);
