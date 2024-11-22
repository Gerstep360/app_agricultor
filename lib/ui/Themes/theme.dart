// lib/ui/Themes/theme.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  // Colores principales y secundarios
  static const Color primaryColor = Color(0xFF00A86B); // Verde esmeralda
  static const Color accentColor = Color(0xFFFFD700); // Dorado para acentos
  static const Color secondaryColor = Color(0xFFFFFFFF); // Blanco para textos y elementos destacados
  static const Color backgroundColor = Color(0xFFE0F7FA); // Azul claro como fondo general
  static const Color surfaceColor = Color(0xFFFFFFFF); // Superficie blanca para tarjetas y contenedores
  static const Color textColor = Color(0xFF000000); // Texto principal, negro
  static const Color hintColor = Color(0xFF616161); // Texto de ayuda, gris oscuro
  static const Color borderColor = Color(0xFF000000); // Bordes negros para definición
  static const Color errorColor = Color(0xFFD32F2F); // Rojo para errores
  // Tema de la aplicación
  static final ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: surfaceColor,
      onPrimary: secondaryColor,
      onSecondary: textColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    hintColor: hintColor,
    dividerColor: borderColor,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    textButtonTheme: _textButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    iconTheme: _iconThemeData,
    bottomNavigationBarTheme: _bottomNavTheme,
    snackBarTheme: _snackBarTheme,
    dialogTheme: _dialogTheme,
    tooltipTheme: _tooltipTheme,
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    switchTheme: _switchTheme,
    sliderTheme: _sliderTheme,
    tabBarTheme: _tabBarTheme,
    dividerTheme: _dividerTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Estilos de texto
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
    displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: textColor),
    displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
    headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: textColor),
    headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor),
    titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textColor),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: textColor),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: textColor),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: accentColor),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: hintColor),
  );

  // Estilo de AppBar
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: secondaryColor),
    titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: secondaryColor),
  );

  // Estilo de ElevatedButton
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: textColor,
      elevation: 4.0,
      shadowColor: borderColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
  );

  // Estilo de TextButton
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    ),
  );

  // Estilo de OutlinedButton
  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: BorderSide(color: borderColor, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
    ),
  );

  // Estilo de InputDecoration (Campos de texto y Dropdown)
  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    hintStyle: TextStyle(color: hintColor),
    labelStyle: TextStyle(color: textColor),
    errorStyle: TextStyle(color: errorColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: borderColor, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: borderColor, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: primaryColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: errorColor, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: errorColor, width: 2.0),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  );

  // Estilo de Iconos
  static const IconThemeData _iconThemeData = IconThemeData(
    color: primaryColor,
    size: 28.0,
  );

  // Estilo de BottomNavigationBar
  static final BottomNavigationBarThemeData _bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: hintColor,
    selectedIconTheme: IconThemeData(size: 30.0),
    unselectedIconTheme: IconThemeData(size: 28.0),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  );

  // Estilo de SnackBar
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: accentColor,
    contentTextStyle: TextStyle(color: textColor, fontSize: 14.0),
    actionTextColor: primaryColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      side: BorderSide(color: borderColor, width: 2.0),
    ),
  );

  // Estilo de Diálogos
  static final DialogTheme _dialogTheme = DialogTheme(
    backgroundColor: surfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      side: BorderSide(color: borderColor, width: 2.0),
    ),
    titleTextStyle: TextStyle(color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: textColor, fontSize: 16.0),
  );

  // Estilo de Tooltip
  static final TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: accentColor,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      border: Border.all(color: borderColor, width: 2.0),
    ),
    textStyle: TextStyle(color: textColor, fontSize: 12.0),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    waitDuration: Duration(milliseconds: 500),
    showDuration: Duration(seconds: 2),
  );

  // Estilo de Checkbox
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
    side: BorderSide(color: borderColor, width: 2.0),
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all<Color>(secondaryColor),
    overlayColor: MaterialStateProperty.all<Color>(primaryColor.withOpacity(0.1)),
  );

  // Estilo de Radio
  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return borderColor;
    }),
    overlayColor: MaterialStateProperty.all<Color>(primaryColor.withOpacity(0.1)),
  );

  // Estilo de Switch
  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor;
      }
      return borderColor;
    }),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return primaryColor.withOpacity(0.5);
      }
      return borderColor.withOpacity(0.5);
    }),
  );

  // Estilo de Slider
  static final SliderThemeData _sliderTheme = SliderThemeData(
    activeTrackColor: primaryColor,
    inactiveTrackColor: borderColor.withOpacity(0.5),
    thumbColor: primaryColor,
    overlayColor: primaryColor.withOpacity(0.1),
    valueIndicatorColor: accentColor,
    valueIndicatorTextStyle: TextStyle(color: textColor),
    trackHeight: 4.0,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
    trackShape: RoundedRectSliderTrackShape(),
  );

  // Estilo de TabBar
  static final TabBarTheme _tabBarTheme = TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: hintColor,
    labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: primaryColor, width: 2.0),
      ),
    ),
  );

  // Estilo de Divider
  static final DividerThemeData _dividerTheme = DividerThemeData(
    color: borderColor,
    thickness: 1.0,
    space: 1.0,
  );
}
class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String status;
  final Color statusColor; // Añadido este parámetro
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
    required this.statusColor, // Añadido este parámetro
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: AppThemes.borderColor,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppThemes.primaryColor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppThemes.primaryColor.withOpacity(0.8),
                    size: 40.sp,
                    shadows: [
                      Shadow(
                        color: AppThemes.borderColor,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppThemes.primaryColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: AppThemes.borderColor,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColor,
                      shadows: [
                        Shadow(
                          color: AppThemes.borderColor,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: statusColor, // Usar el color proporcionado
                    size: 12.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Estado: $status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppThemes.textColor,
                          shadows: [
                            Shadow(
                              color: AppThemes.borderColor,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}