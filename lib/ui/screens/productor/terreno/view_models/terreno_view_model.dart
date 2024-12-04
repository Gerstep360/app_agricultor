// lib/ui/screens/productor/terreno/view_models/terreno_view_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/services/api_service.dart';
import 'package:agromarket_app/ui/screens/maps/map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class TerrenoViewModel extends ChangeNotifier {
  final int agricultorId;
  final ApiService _apiService = ApiService();

  List<Terreno> _terrenos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  List<Terreno> get terrenos => _terrenos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  TerrenoViewModel({required this.agricultorId}) {
    fetchTerrenos();
  }

  Future<void> fetchTerrenos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final terrenos = await _apiService.Agricultor_getTerrenos(agricultorId);
      _terrenos = terrenos;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error al obtener terrenos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTerreno(Map<String, dynamic> terrenoData) async {
    try {
      final nuevoTerreno = await _apiService.Terreno_createTerreno(terrenoData);
      _terrenos.add(nuevoTerreno);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al agregar terreno: $e';
      notifyListeners();
    }
  }

  Future<void> updateTerreno(int terrenoId, Map<String, dynamic> terrenoData) async {
    try {
      final terrenoActualizado = await _apiService.Terreno_updateTerreno(terrenoId, terrenoData);
      final index = _terrenos.indexWhere((t) => t.id == terrenoId);
      if (index != -1) {
        _terrenos[index] = terrenoActualizado;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar terreno: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTerreno(int terrenoId) async {
    try {
      await _apiService.Terreno_deleteTerreno(terrenoId);
      _terrenos.removeWhere((t) => t.id == terrenoId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar terreno: $e';
      notifyListeners();
    }
  }
}
