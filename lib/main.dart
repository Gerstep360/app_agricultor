import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agromarket_app/ui/Themes/theme.dart';
import 'package:agromarket_app/services/Agricultor/notificaciones.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:agromarket_app/ui/rutas.dart'; // Asegúrate de tener este archivo de rutas
import 'package:agromarket_app/ui/navegador.dart'; // Importa el AppNavegador
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configuración de notificaciones
  final NotificacionesService notificacionesService = NotificacionesService();
  notificacionesService.inicializarNotificaciones();
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

  // Copiar el token al portapapeles para pruebas
  await notificacionesService.copiarTokenAlPortapapeles();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _agricultorId;
  int? _clienteId;
  // Verificar si el usuario está logueado
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('agricultorId')) {
      setState(() {
        _agricultorId = prefs.getInt('clienteId');
      });
    }
        if (prefs.containsKey('cliented')) {
      setState(() {
        _clienteId = prefs.getInt('clienteId');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroMarket',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.appTheme,
      navigatorKey: AppNavegador.instance.navegadorKey, // Integrar AppNavegador
      onGenerateRoute: AppRoutes.generateRoute, // Usar rutas centralizadas
      initialRoute: AppRoutes.splash, // Ruta inicial
    );
  }
}
