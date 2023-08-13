import 'package:flutter/material.dart';

ThemeData themeData() => ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffffae00),
          primary: const Color(0xff955007),
          secondary: const Color(0xfff6f6da),
          // tertiary: Colors.black,
          tertiary: const Color(0xff766076)),
      scaffoldBackgroundColor: const Color(0xfff4e4c6),
      primaryColor: const Color(0xff955007),
      useMaterial3: true,
    );
