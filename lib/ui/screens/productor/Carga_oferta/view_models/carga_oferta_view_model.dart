// lib/ui/screens/productor/carga_oferta/view_models/carga_oferta_view_model.dart

import 'package:flutter/material.dart';
import 'package:agromarket_app/models/Agricultor/carga_oferta.dart';
import 'package:agromarket_app/services/api_service.dart';

class CargaOfertaViewModel extends ChangeNotifier {
  final int agricultorId;
  final ApiService _apiService = ApiService();

  List<CargaOferta> _cargas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  List<CargaOferta> get cargas => _cargas;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  CargaOfertaViewModel({required this.agricultorId}) {
    fetchCargas();
  }

  Future<void> fetchCargas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cargas = await _apiService.Agricultor_getCargasofertas(agricultorId);
      _cargas = cargas;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error al obtener cargas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateCargaOferta(int cargaId, Map<String, dynamic> cargaData) async {
    try {
      final cargaActualizada = await _apiService.CargaOferta_updateCarga(cargaId, cargaData);
      final index = _cargas.indexWhere((c) => c.id == cargaId);
      if (index != -1) {
        _cargas[index] = cargaActualizada;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar carga: $e';
      notifyListeners();
    }
  }

}
