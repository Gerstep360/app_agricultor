import 'package:agromarket_app/ui/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:agromarket_app/ui/screens/auth/login_screen.dart';
import 'package:agromarket_app/ui/screens/productor/home/home_screen.dart';
import 'package:agromarket_app/ui/screens/productor/Carga_oferta/Carga_oferta.dart';
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String carga_oferta = '/cargaOferta';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        final int agricultorId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(agricultorId: agricultorId),
        );

      case carga_oferta:
        final int agricultorId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CargaOfertaScreen(agricultorId: agricultorId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Pantalla no encontrada')),
          ),
        );
    }
  }
}
