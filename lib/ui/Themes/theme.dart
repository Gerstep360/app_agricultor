// lib/ui/Themes/theme.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  // Colores principales y secundarios
  static const Color primaryColor = Color(0xFF77910A); // Verde oscuro para botones y textos principales
  static const Color accentColor = Color(0xFFF6D2C6); // Rosa claro para acentos y textos dentro de botones
  static const Color secondaryColor = Color(0xFFFFFFFF); // Blanco para elementos destacados
  static const Color backgroundColor = Color(0xFFF6D2C6); // Rosa claro como fondo general
  static const Color surfaceColor = Color(0xFF77910A); // Verde oscuro para tarjetas y contenedores
  static const Color textColor = Color(0xFFF6D2C6); // Texto dentro de widgets, rosa claro
  static const Color outsideTextColor = Color(0xFF77910A); // Texto fuera de widgets, verde oscuro
  static const Color hintColor = Color(0xFF616161); // Texto de ayuda, gris oscuro
  static const Color borderColor = Color(0xFF77910A); // Bordes verde oscuro para definición
  static const Color errorColor = Color(0xFFD32F2F); // Rojo para errores
  static const Color successColor = Color(0xFF28A745); // Verde para mensajes de éxito
  static const Color warningColor = Color(0xFFFFC107); // Ámbar para advertencias

  // Tema de la aplicación
  static final ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: surfaceColor,
      onPrimary: accentColor, // Texto dentro de botones
      onSecondary: primaryColor, // Texto fuera de botones
      error: errorColor,
      onError: secondaryColor,
      onBackground: outsideTextColor,
      onSurface: primaryColor,
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
    iconTheme: IconThemeData(color: accentColor),
    titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: accentColor),
  );

  // Estilo de ElevatedButton
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor, // Botones verdes
      foregroundColor: accentColor, // Texto dentro de botones
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
      foregroundColor: primaryColor, // Texto fuera de botones
      textStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
    ),
  );

  // Estilo de OutlinedButton
  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor, // Texto fuera de botones
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
    color: accentColor, // Iconos en rosa claro
    size: 28.0,
  );

  // Estilo de BottomNavigationBar
  static final BottomNavigationBarThemeData _bottomNavTheme = BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    selectedItemColor: accentColor,
    unselectedItemColor: hintColor,
    selectedIconTheme: IconThemeData(size: 30.0, color: accentColor),
    unselectedIconTheme: IconThemeData(size: 28.0, color: hintColor),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  );

  // Estilo de SnackBar
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    backgroundColor: primaryColor,
    contentTextStyle: TextStyle(color: accentColor, fontSize: 14.0),
    actionTextColor: accentColor,
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
    titleTextStyle: TextStyle(color: accentColor, fontSize: 20.0, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: accentColor, fontSize: 16.0),
  );

  // Estilo de Tooltip
  static final TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      border: Border.all(color: borderColor, width: 2.0),
    ),
    textStyle: TextStyle(color: accentColor, fontSize: 12.0),
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
    checkColor: MaterialStateProperty.all<Color>(accentColor),
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
    labelColor: accentColor,
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
  final String? status; // Nullable
  final Color? statusColor; // Nullable
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.status, // Nullable
    this.statusColor, // Nullable
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppThemes.surfaceColor, // Fondo verde oscuro
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppThemes.accentColor, // Icono en rosa claro
                    size: 40.0,
                    shadows: [
                      Shadow(
                        color: AppThemes.borderColor,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppThemes.textColor, // Texto en rosa claro
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
              SizedBox(height: 8.0),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColor, // Texto en rosa claro
                      shadows: [
                        Shadow(
                          color: AppThemes.borderColor,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
              ),
              if (status != null && statusColor != null) ...[
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
                            color: AppThemes.textColor, // Texto en rosa claro
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
            ],
          ),
        ),
      ),
    );
  }
}
