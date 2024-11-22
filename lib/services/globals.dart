// FONTS

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//const String baseURL = "http://137.184.196.1/";
const String ip = "172.20.10.10";
const String baseURL = "http://$ip:8080/api";

const backgroundPrimary = Color(0XFF2B5F53);

const backgroundSecondary = Color.fromARGB(255, 55, 134, 132);
const backgroundOptional = Color.fromARGB(255, 205, 203, 203);
const backgroundOptional1 = Color(0xFF3A8171);
ThemeData poppins = ThemeData(
  primarySwatch: Colors.teal, // Color principal de la aplicación
  colorScheme: const ColorScheme.light(
    primary: backgroundPrimary, // Color principal (encabezado y selección)
    onPrimary: Colors.white, // Color del texto en el encabezado
    onSurface: Colors.black, // Color del texto en el calendario
  ),
  useMaterial3: true,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 60.sp)), // Muy grande
    displayMedium:
        GoogleFonts.poppins(textStyle: TextStyle(fontSize: 48.sp)), // Grande
    displaySmall:
        GoogleFonts.poppins(textStyle: TextStyle(fontSize: 40.sp)), // Mediano
    headlineLarge: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 34.sp)), // Título grande
    headlineMedium: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 28.sp)), // Título medio
    headlineSmall: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 24.sp)), // Título pequeño
    titleLarge: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 20.sp)), // Subtítulo grande
    titleMedium: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 18.sp)), // Subtítulo mediano
    titleSmall: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 16.sp)), // Subtítulo pequeño
    bodyLarge: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 16.sp)), // Texto de cuerpo
    bodyMedium: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 14.sp)), // Cuerpo mediano
    bodySmall: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 12.sp)), // Cuerpo pequeño
    labelLarge: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 16.sp)), // Etiqueta grande
    labelMedium: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 14.sp)), // Etiqueta mediana
    labelSmall: GoogleFonts.poppins(
        textStyle: TextStyle(fontSize: 12.sp)), // Etiqueta pequeña
  ),
);

const Map<String, String> headers = {"Content-Type": "application/json"};
