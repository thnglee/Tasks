import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color Scheme Constants
  static const Color primaryGrey = Color(0xFF4B4B54);
  static const Color lightGrey = Color(0xFF6C6B6B);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Light Theme Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGrey = Color(0xFF6B7280);

  // Pre-calculated Colors with Opacity
  static const Color containerBackgroundColor = Color(0x1AFFFFFF); // 10% white
  static const Color containerBackgroundColorLight = Color(
    0x1A000000,
  ); // 10% black
  static const Color borderColor = Color(0x33FFFFFF); // 20% white
  static const Color borderColorLight = Color(0x33000000); // 20% black
  static const Color hintTextColor = Color(0xB3FFFFFF); // 70% white
  static const Color hintTextColorLight = Color(0xB3000000); // 70% black
  static const Color unselectedIconColor = Color(
    0x4857636C,
  ); // Original nav unselected color

  // Navigation Colors
  static const Color navBarBackground = Color(0xFFCACACA);

  // Gradient Colors
  static const List<Color> backgroundGradientColors = [
    lightGrey,
    primaryGrey,
    darkGrey,
  ];

  static const List<double> backgroundGradientStops = [0.0, 0.5, 1.0];

  static const AlignmentDirectional backgroundGradientBegin =
      AlignmentDirectional(1.0, -1.0);
  static const AlignmentDirectional backgroundGradientEnd =
      AlignmentDirectional(-1.0, 1.0);

  // Gradient Decoration
  static BoxDecoration getBackgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        colors:
            isDark ? backgroundGradientColors : backgroundGradientColorsLight,
        stops: backgroundGradientStops,
        begin: backgroundGradientBegin,
        end: backgroundGradientEnd,
      ),
    );
  }

  // Light Theme Gradient Colors
  static const List<Color> backgroundGradientColorsLight = [
    backgroundLight,
    surfaceLight,
    Color(0xFFE0E0E0),
  ];

  // Common Border Radius
  static const double borderRadius = 15.0;
  static final BorderRadius commonBorderRadius = BorderRadius.circular(
    borderRadius,
  );

  // Common Decorations
  static final BoxDecoration glassmorphicDecoration = BoxDecoration(
    color: containerBackgroundColor,
    borderRadius: commonBorderRadius,
  );

  static final BoxDecoration glassmorphicButtonDecoration = BoxDecoration(
    borderRadius: commonBorderRadius,
    color: primaryGrey,
  );

  // Input Decorations
  static final InputDecoration glassmorphicInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: hintTextColor),
    border: OutlineInputBorder(
      borderRadius: commonBorderRadius,
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: commonBorderRadius,
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: commonBorderRadius,
      borderSide: const BorderSide(color: white),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
  );

  // Text Styles
  static final TextStyle headlineStyle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static final TextStyle bodyStyle = GoogleFonts.inter(
    fontSize: 16,
    color: white,
  );

  static final TextStyle buttonStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  // Checkbox Styles
  static final WidgetStateProperty<Color> checkboxFillColor =
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return primaryGrey;
        }
        return transparent;
      });

  static final BorderSide checkboxBorderSide = BorderSide(color: borderColor);

  // Padding and Spacing
  static const EdgeInsets defaultPadding = EdgeInsets.all(15.0);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: 15.0,
  );
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(
    vertical: 15.0,
  );
  static const double defaultSpacing = 10.0;

  // Icon Sizes
  static const double defaultIconSize = 24.0;

  // Common Decorations for Light Theme
  static final BoxDecoration glassmorphicDecorationLight = BoxDecoration(
    color: containerBackgroundColorLight,
    borderRadius: commonBorderRadius,
  );

  static final BoxDecoration glassmorphicButtonDecorationLight = BoxDecoration(
    borderRadius: commonBorderRadius,
    color: primaryBlue,
  );

  // Input Decorations for Light Theme
  static final InputDecoration glassmorphicInputDecorationLight =
      InputDecoration(
        hintStyle: TextStyle(color: hintTextColorLight),
        border: OutlineInputBorder(
          borderRadius: commonBorderRadius,
          borderSide: BorderSide(color: borderColorLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: commonBorderRadius,
          borderSide: BorderSide(color: borderColorLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: commonBorderRadius,
          borderSide: BorderSide(color: primaryBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      );

  // Text Styles for Light Theme
  static final TextStyle headlineStyleLight = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static final TextStyle bodyStyleLight = GoogleFonts.inter(
    fontSize: 16,
    color: textDark,
  );

  static final TextStyle buttonStyleLight = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  // Color Scheme Constants
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryPurpleLight = Color(0xFFA78BFA);
  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2C2C2E);
  static const Color darkBorder = Color(0xFF3C3C3E);

  // Border Styles
  static const double borderWidth = 1.0;
  static final Border purpleDottedBorder = Border.all(
    color: primaryPurple.withOpacity(0.5),
    width: borderWidth,
    strokeAlign: BorderSide.strokeAlignOutside,
  );

  // Task Item Styles
  static final BoxDecoration taskItemDecoration = BoxDecoration(
    color: darkSurface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: darkBorder, width: borderWidth),
  );

  // Task Item Light Theme Styles
  static final BoxDecoration taskItemDecorationLight = BoxDecoration(
    color: surfaceLight,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderLight, width: borderWidth),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Material Theme Data
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryPurple,
      secondary: primaryPurpleLight,
      surface: darkSurface,
      onSurface: textLight,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: textLight),
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
    ),
  );

  // Light Theme Data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryPurple,
      secondary: primaryPurpleLight,
      surface: surfaceLight,
      onSurface: textDark,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: textDark),
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
    ),
  );
}
