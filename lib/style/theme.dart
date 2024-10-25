import 'package:flutter/material.dart';

ThemeData themeData() => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffFF4D00),
        primary: const Color(0xffFF4D00),
        secondary: const Color(0xff415A77),
        tertiary: const Color(0xffE0E1DD),
      ),
      scaffoldBackgroundColor: const Color(0xff0D1B2A),
      primaryColor: const Color(0xffFF4D00),
      useMaterial3: true,
    );
