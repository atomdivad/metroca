import 'package:flutter/material.dart';

class AppTamanhos {}

class AppCores {
  static const red = Color(0xFFDB3022);
  static const black = Color(0xFF222222);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const blue = Color.fromARGB(255, 26, 154, 223);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
}

class AppConsts {
  static const page_size = 20;
}

class MeTrocaTema {
  static ThemeData of(context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Color.fromARGB(255, 136, 56, 56),
      primaryColorLight: const Color.fromARGB(255, 155, 155, 155),
      hintColor: AppCores.red,
      dialogBackgroundColor: Color.fromARGB(255, 6, 6, 6),
      dividerColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
        color: AppCores.blue,
        iconTheme: IconThemeData(color: AppCores.black),
      ),
      textTheme: theme.textTheme
          .copyWith(
            headlineSmall: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 48,
              color: AppCores.blue,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w900,
            ),
            titleLarge: theme.textTheme.titleLarge?.copyWith(
              fontSize: 24,
              color: AppCores.black,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto-Black',
            ),
            headlineMedium: theme.textTheme.headlineMedium?.copyWith(
              color: AppCores.black,
              fontSize: 26,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto-Black',
            ),
            displaySmall: theme.textTheme.displaySmall?.copyWith(
              fontFamily: 'Roboto-Black',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            displayMedium: theme.textTheme.displayMedium?.copyWith(
              color: AppCores.lightGray,
              fontSize: 14,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w400,
            ),
            displayLarge: theme.textTheme.displayLarge?.copyWith(
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w500,
            ),
            titleSmall: theme.textTheme.titleSmall?.copyWith(
              fontSize: 18,
              color: AppCores.black,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w400,
            ),
            titleMedium: theme.textTheme.titleMedium?.copyWith(
              fontSize: 24,
              color: AppCores.darkGray,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w500,
            ),
            labelLarge: theme.textTheme.labelLarge?.copyWith(
              fontSize: 14,
              color: AppCores.blue,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w500,
            ),
            bodySmall: theme.textTheme.bodySmall?.copyWith(
              fontSize: 34,
              color: AppCores.black,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w700,
            ),
            bodyLarge: theme.textTheme.bodyLarge?.copyWith(
              color: AppCores.lightGray,
              fontSize: 11,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w400,
            ),
            bodyMedium: theme.textTheme.bodyMedium?.copyWith(
              color: AppCores.black,
              fontSize: 11,
              fontFamily: 'Roboto-Black',
              fontWeight: FontWeight.w400,
            ),
          )
          .apply(fontFamily: 'Roboto-Black'),
      buttonTheme: theme.buttonTheme.copyWith(
        minWidth: 10,
        buttonColor: AppCores.blue,
      ),
    );
  }
}
