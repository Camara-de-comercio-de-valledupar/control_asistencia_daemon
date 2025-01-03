import 'package:flutter/material.dart';

var primaryTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: Colors.blue,
  primaryColor: const Color(0xFF0070B3),
  fontFamily: "Geomanist",
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
    bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
    bodySmall: TextStyle(color: Color(0xFFF2F2F2)),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0070B3),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFFF2F2F2),
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    iconTheme: IconThemeData(color: Color(0xFFF2F2F2)),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF0070B3),
    textTheme: ButtonTextTheme.primary,
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0070B3),
    onPrimary: Color(0xFFF2F2F2),
    secondary: Color(0xFF19255A),
    onSecondary: Color(0xFFF2F2F2),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFF2F2F2),
    onSurface: Color(0xFFF2F2F2),
    surface: Color(0xFF0070B3),
  ),
  // Change input text color
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFFF2F2F2)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF0070B3)),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF0070B3)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF0070B3)),
      ),
      focusColor: Color(0xFF0070B3),
      hintStyle: TextStyle(color: Color(0xFFF2F2F2)),
      prefixIconColor: Color(0xFF0070B3),
      iconColor: Color(0xFFF2F2F2),
      suffixIconColor: Color(0xFFF2F2F2),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF0070B3)),
      elevation: WidgetStateProperty.all<double>(0),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(color: Color(0xFF0070B3)),
      ),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Color(0xFF0070B3)),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0070B3)),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0070B3)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0070B3)),
    ),
    focusColor: Color(0xFF0070B3),
    hintStyle: TextStyle(color: Color(0xFFF2F2F2)),
    prefixIconColor: Color(0xFF0070B3),
    iconColor: Color(0xFFF2F2F2),
    suffixIconColor: Color(0xFFF2F2F2),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF7A7A7A),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0070B3),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0070B3),
    selectedItemColor: Color(0xFF54595F),
    unselectedItemColor: Color(0xFF7A7A7A),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF0070B3),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF0070B3),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF0070B3),
    contentTextStyle: TextStyle(color: Color(0xFF54595F)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF0070B3)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(
      const Color(0xFF0070B3),
    ),
    elevation: WidgetStateProperty.all<double>(0.0),
    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
    ),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    foregroundColor: WidgetStateProperty.all<Color>(
      const Color(0xFFF2F2F2),
    ),
  )),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(
          width: 2,
          color: Color(0xFF0070B3),
        ),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFF0070B3)),
    ),
  ),
);
