import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/ui/navegador.dart';
import 'package:agromarket_app/ui/rutas.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('agricultorId')) {
      // Obtener agricultorId de las preferencias
      int agricultorId = prefs.getInt('agricultorId')!;
      AppNavegador.instance.setAgricultorId(agricultorId);

      // Navegar al HomeScreen automáticamente
      AppNavegador.instance.reemplazarCon(
        AppRoutes.home,
        arguments: agricultorId,
      );
      
    } 
        if (prefs.containsKey('clienteId')) {
      // Obtener agricultorId de las preferencias
      int clienteId = prefs.getInt('clienteId')!;
      AppNavegador.instance.setAgricultorId(clienteId);

      // Navegar al HomeScreen automáticamente
      AppNavegador.instance.reemplazarCon(
        AppRoutes.home_cliente,
        arguments: clienteId,
      );
      
    }
    else {
      // Navegar al LoginScreen si no hay agricultorId
      AppNavegador.instance.reemplazarCon(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
