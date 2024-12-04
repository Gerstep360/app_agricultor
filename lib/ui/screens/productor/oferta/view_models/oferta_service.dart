import 'package:flutter/material.dart';
import 'package:agromarket_app/models/Agricultor/oferta.dart';
import 'package:agromarket_app/models/Agricultor/oferta_detalle.dart';
import 'package:agromarket_app/models/Agricultor/produccion.dart';
import 'package:agromarket_app/models/Agricultor/unidad_medida.dart';
import 'package:agromarket_app/models/Agricultor/moneda.dart';
import 'package:agromarket_app/services/api_service.dart';

class OfertaService extends ChangeNotifier {
  final int agricultorId;
  final ApiService _apiService = ApiService();

  List<Oferta> ofertas = [];
  List<OfertaDetalle> detalles = [];
  List<Produccion> producciones = [];
  List<UnidadMedida> unidadesMedida = [];
  List<Moneda> monedas = [];

  String errorMessage = '';
  bool isLoading = false;

  OfertaService({required this.agricultorId});

  /// Carga todos los datos necesarios en paralelo
  Future<void> fetchAllData() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final results = await Future.wait([
        _apiService.Agricultor_getProducciones(agricultorId),
        _apiService.Unidad_medida_getUnidadMedidas(),
        _apiService.Monedas_getMonedas(),
        _apiService.Agricultor_getOfertas(agricultorId),
        _apiService.Agricultor_getOfertas_detalles(agricultorId),
      ]);

      producciones = results[0] as List<Produccion>;
      unidadesMedida = results[1] as List<UnidadMedida>;
      monedas = results[2] as List<Moneda>;
      ofertas = results[3] as List<Oferta>;
      detalles = results[4] as List<OfertaDetalle>;
    } catch (e) {
      errorMessage = 'Error al obtener datos de ofertas: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Agrega una nueva oferta y su detalle, retornando los objetos creados
  Future<Map<String, dynamic>> addOferta(Oferta newOferta, OfertaDetalle newDetalle) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final createdOferta = await _apiService.Ofertas_createOferta(newOferta.toJson());

      if (createdOferta.id == null || createdOferta.id! <= 0) {
        throw Exception('ID de Oferta no válido.');
      }

      final newDetalleWithOferta = newDetalle.copyWith(idOferta: createdOferta.id);

      final createdDetalle = await _apiService.Ofertas_detalle_createOfertaDetalle(newDetalleWithOferta.toJson());

      if (createdDetalle.id == null || createdDetalle.id! <= 0) {
        throw Exception('ID de OfertaDetalle no válido.');
      }

      ofertas.add(createdOferta);
      detalles.add(createdDetalle);

      notifyListeners();

      return {
        'oferta': createdOferta,
        'detalle': createdDetalle,
      };
    } catch (e) {
      errorMessage = 'Error al agregar oferta: $e';
      notifyListeners();
      return {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza una oferta existente y su detalle
  Future<void> updateOferta(Oferta updatedOferta, OfertaDetalle updatedDetalle) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      if (updatedOferta.id == null) {
        throw Exception('ID de Oferta no puede ser nulo al actualizar.');
      }
      if (updatedDetalle.id == null) {
        throw Exception('ID de OfertaDetalle no puede ser nulo al actualizar.');
      }

      final ofertaResponse = await _apiService.Ofertas_updateOferta(updatedOferta.id!, updatedOferta.toJson());

      final detalleResponse = await _apiService.Ofertas_detalle_updateOfertaDetalle(updatedDetalle.id!, updatedDetalle.toJson());

      final ofertaIndex = ofertas.indexWhere((o) => o.id == ofertaResponse.id);
      if (ofertaIndex != -1) {
        ofertas[ofertaIndex] = ofertaResponse;
      }

      final detalleIndex = detalles.indexWhere((d) => d.id == detalleResponse.id);
      if (detalleIndex != -1) {
        detalles[detalleIndex] = detalleResponse;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al actualizar oferta: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Elimina una oferta y sus detalles asociados
  Future<void> deleteOferta(int ofertaId) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      await _apiService.deleteOferta(ofertaId);

      ofertas.removeWhere((o) => o.id == ofertaId);
      detalles.removeWhere((d) => d.idOferta == ofertaId);

      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al eliminar oferta: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Métodos auxiliares para obtener datos
  OfertaDetalle? getDetalleByOfertaId(int ofertaId) {
    try {
      return detalles.firstWhere((d) => d.idOferta == ofertaId);
    } catch (_) {
      return null;
    }
  }

  Produccion? getProduccionById(int produccionId) {
    try {
      return producciones.firstWhere((p) => p.id == produccionId);
    } catch (_) {
      return null;
    }
  }

  UnidadMedida? getUnidadMedidaById(int unidadMedidaId) {
    try {
      return unidadesMedida.firstWhere((u) => u.id == unidadMedidaId);
    } catch (_) {
      return null;
    }
  }

  Moneda? getMonedaById(int monedaId) {
    try {
      return monedas.firstWhere((m) => m.id == monedaId);
    } catch (_) {
      return null;
    }
  }
}
