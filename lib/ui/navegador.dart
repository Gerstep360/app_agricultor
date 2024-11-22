import 'package:flutter/material.dart';

class AppNavegador {
  // Singleton para asegurar que haya una única instancia
  AppNavegador._privateConstructor();
  static final AppNavegador instance = AppNavegador._privateConstructor();

  // GlobalKey para controlar el estado del navegador
  final GlobalKey<NavigatorState> navegadorKey = GlobalKey<NavigatorState>();

  // Agricultor ID
  int? agricultorId;

  /// Navegar a una ruta específica
  void navegarScreen(String ruta, {Object? arguments}) {
    // Verificar si la ruta actual es diferente antes de navegar
    if (_currentRoute != ruta) {
      navegadorKey.currentState?.pushNamed(ruta, arguments: arguments);
    } else {
      print('Ya estás en la pantalla $ruta, navegación cancelada.');
    }
  }

  /// Reemplazar toda la pila de navegación con una nueva ruta
  void reemplazarCon(String ruta, {Object? arguments}) {
    // Verificar si la ruta actual es diferente antes de reemplazar
    if (_currentRoute != ruta) {
      navegadorKey.currentState?.pushReplacementNamed(ruta, arguments: arguments);
    } else {
      print('Ya estás en la pantalla $ruta, navegación cancelada.');
    }
  }

  /// Navegar hacia atrás
  void volverAtras() {
    if (navegadorKey.currentState?.canPop() ?? false) {
      navegadorKey.currentState?.pop();
    }
  }

  /// Obtener la ruta actual
  String? get _currentRoute {
    return navegadorKey.currentState?.overlay?.context.widget.toString();
  }

  /// Configurar agricultor ID (por ejemplo, desde SplashScreen)
  void setAgricultorId(int id) {
    agricultorId = id;
  }

  /// Obtener agricultor ID
  int? getAgricultorId() {
    return agricultorId;
  }
}
