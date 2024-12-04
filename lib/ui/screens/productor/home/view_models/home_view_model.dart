// lib/ui/screens/productor/home/view_models/home_view_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/screens/auth/login_screen.dart';

class HomeViewModel extends ChangeNotifier {
  final int agricultorId;
  bool isLoading = false;
  String errorMessage = '';

  HomeViewModel({required this.agricultorId});

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedAgricultorId = prefs.getInt('agricultorId');

    if (storedAgricultorId != null) {
      try {
        await ApiService().put(
          '/agricultors/$storedAgricultorId',
          {'tokendevice': null},
        );
      } catch (e) {
        errorMessage = 'Error al cerrar sesión: $e';
        isLoading = false;
        notifyListeners();
        return;
      }
    }

    await prefs.remove('agricultorId');

    isLoading = false;
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // Aquí puedes añadir más métodos relacionados con la lógica de la pantalla de inicio
}
