import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'size_config.dart';

class Typo {
  Typo._();

// final
  static TextStyle displayLarge = TextStyle(
    fontSize: SizeConfig.getPercentSize(8),
    fontWeight: FontWeight.w600,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: SizeConfig.getPercentSize(7),
    fontWeight: FontWeight.w600,
    // letterSpacing: -0.5,
  );

// final
  static TextStyle displaySmall = TextStyle(
    fontSize: SizeConfig.getPercentSize(5),
    fontWeight: FontWeight.w700,
  );

  static TextStyle headlineLarge = TextStyle(
    fontSize: SizeConfig.getPercentSize(7),
    fontWeight: FontWeight.w500,
    // letterSpacing: 0.25,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: 34.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.25,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: SizeConfig.getPercentSize(3.5),
    fontWeight: FontWeight.w300,
    // letterSpacing: 1.5,
  );

//final
  static TextStyle titleLarge = TextStyle(
    // static TextStyle titleLarge = GoogleFonts.montserrat(
    fontSize: SizeConfig.getPercentSize(5.5),
    fontWeight: FontWeight.w600,
    // letterSpacing: 0.15,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: SizeConfig.getPercentSize(5),
    fontWeight: FontWeight.w500,
    // letterSpacing: 0.15,
  );
//final
  static TextStyle titleSmall = TextStyle(
    fontSize: SizeConfig.getPercentSize(4.4),
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.1,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: SizeConfig.getPercentSize(5.5),
    fontWeight: FontWeight.w600,
    // letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: SizeConfig.getPercentSize(4.8),
    fontWeight: FontWeight.w500,
    // letterSpacing: 0.25,
  );
//final
  static TextStyle bodySmall = TextStyle(
    fontSize: SizeConfig.getPercentSize(3.8),
    fontWeight: FontWeight.w600,
    // letterSpacing: 0.4,
  );

  static TextStyle labelLarge = TextStyle(
    fontSize: SizeConfig.getPercentSize(5),
    fontWeight: FontWeight.w600,
  );
//final
  static TextStyle labelMedium = GoogleFonts.roboto(
    fontSize: SizeConfig.getPercentSize(4),
    fontWeight: FontWeight.w500,
  );

//final
  static TextStyle labelSmall = GoogleFonts.roboto(
    fontSize: SizeConfig.getPercentSize(3.5),
    fontWeight: FontWeight.w500,
    // letterSpacing: 1.5,
  );
}
