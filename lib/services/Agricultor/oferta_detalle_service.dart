// services/oferta_detalle_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/oferta_detalle.dart';

class OfertaDetalleService {
  final ApiService _apiService;

  OfertaDetalleService(this._apiService);

  // Obtener todos los detalles de ofertas
  Future<List<OfertaDetalle>> getOfertaDetalles() async {
    final data = await _apiService.get('/oferta_detalles');
    return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
  }

  // Crear un nuevo detalle de oferta
  Future<OfertaDetalle> createOfertaDetalle(Map<String, dynamic> detalleData) async {
    final data = await _apiService.post('/oferta_detalles', detalleData);
    return OfertaDetalle.fromJson(data);
  }

  // Mostrar detalles de un detalle de oferta específica
  Future<OfertaDetalle> getOfertaDetalle(int id) async {
    final data = await _apiService.get('/oferta_detalles/$id');
    return OfertaDetalle.fromJson(data);
  }

  // Actualizar datos de un detalle de oferta
  Future<OfertaDetalle> updateOfertaDetalle(int id, Map<String, dynamic> detalleData) async {
    final data = await _apiService.put('/oferta_detalles/$id', detalleData);
    return OfertaDetalle.fromJson(data);
  }

  // Eliminar un detalle de oferta
  Future<void> deleteOfertaDetalle(int id) async {
    await _apiService.delete('/oferta_detalles/$id');
  }

  // Verificar disponibilidad de cantidad física en la oferta
  Future<bool> checkDisponibilidad(int id) async {
    final data = await _apiService.get('/oferta_detalles/$id/disponibilidad');
    return data['disponible'];
  }

    // Obtener los detalles de una oferta específica
  Future<List<OfertaDetalle>> getOfertaDetallesByOfertaId(int ofertaId) async {
    final data = await _apiService.get('/ofertas/$ofertaId/detalles');
    return (data as List).map((json) => OfertaDetalle.fromJson(json)).toList();
  }
}
