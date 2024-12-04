// lib/ui/screens/productor/produccion/view_models/produccion_service.dart

import 'package:flutter/material.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/terreno.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/producto.dart';
import 'package:agromarket_app/models/Agricultor/temporada.dart';
import 'package:agromarket_app/services/api_service.dart';

class ProduccionService extends ChangeNotifier {
  final int agricultorId;
  final ApiService _apiService = ApiService();

  List<Produccion> producciones = [];
  List<Terreno> terrenos = [];
  List<UnidadMedida> unidadesMedida = [];
  List<Producto> productos = [];
  List<Temporada> temporadas = [];

  bool isLoading = true;
  String errorMessage = '';

  ProduccionService({required this.agricultorId});

  /// Carga todos los datos necesarios en paralelo
  Future<void> fetchAllData() async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.Unidad_medida_getUnidadMedidas(),
        _apiService.Agricultor_getProducciones(agricultorId),
        _apiService.Producto_Producto_getProductos(),
        _apiService.Temporada_getTemporadas(),
        _apiService.getTerrenosByAgricultor(agricultorId),
      ]);

      unidadesMedida = results[0] as List<UnidadMedida>;
      producciones = results[1] as List<Produccion>;
      productos = results[2] as List<Producto>;
      temporadas = results[3] as List<Temporada>;
      terrenos = results[4] as List<Terreno>;

      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error al obtener datos de producciones: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Agrega una nueva producción
  Future<void> addProduccion(Produccion nuevaProduccion) async {
    try {
      isLoading = true;
      notifyListeners();

      final createdProduccion =
          await _apiService.Produccion_createProduccion(nuevaProduccion.toJson());

      producciones.add(createdProduccion);
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error al agregar producción: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza una producción existente
  Future<void> updateProduccion(Produccion updatedProduccion) async {
    try {
      isLoading = true;
      notifyListeners();

      final produccionResponse = await _apiService.Produccion_updateProduccion(
          updatedProduccion.id, updatedProduccion.toJson());

      final index =
          producciones.indexWhere((produccion) => produccion.id == produccionResponse.id);
      if (index != -1) {
        producciones[index] = produccionResponse;
      }

      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error al actualizar producción: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina una producción
  Future<void> deleteProduccion(int produccionId) async {
    try {
      isLoading = true;
      notifyListeners();

      await _apiService.Produccion_deleteProduccion(produccionId);

      producciones.removeWhere((produccion) => produccion.id == produccionId);
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error al eliminar producción: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene una producción por su ID
  Produccion? getProduccionById(int produccionId) {
    try {
      return producciones.firstWhere((p) => p.id == produccionId);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene una unidad de medida por su ID
  UnidadMedida? getUnidadMedidaById(int unidadMedidaId) {
    try {
      return unidadesMedida.firstWhere((u) => u.id == unidadMedidaId);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene un terreno por su ID
  Terreno? getTerrenoById(int terrenoId) {
    try {
      return terrenos.firstWhere((t) => t.id == terrenoId);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene una temporada por su ID
  Temporada? getTemporadaById(int temporadaId) {
    try {
      return temporadas.firstWhere((t) => t.id == temporadaId);
    } catch (_) {
      return null;
    }
  }
}
