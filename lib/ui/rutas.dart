import 'package:agromarket_app/ui/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:agromarket_app/ui/screens/productor/home/home_screen.dart';
import 'package:agromarket_app/ui/screens/Cliente/home/client_home_screen.dart';
import 'package:agromarket_app/ui/screens/productor/Carga_oferta/Carga_oferta.dart';
import 'package:agromarket_app/ui/screens/Roles/role_selection_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String home_cliente = '/home_cliente';
  static const String carga_oferta = '/cargaOferta';
  static const String rol = '/rol';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => RoleSelectionScreen());
      case home_cliente:
        final int clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ClientHomeScreen(clienteId: clienteId),
        );
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
