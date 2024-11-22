// services/oferta_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/oferta.dart';

class OfertaService {
  final ApiService _apiService;

  OfertaService(this._apiService);

  // Obtener todas las ofertas
  Future<List<Oferta>> getOfertas() async {
    final data = await _apiService.get('/ofertas');
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  }

  // Crear una nueva oferta
  Future<Oferta> createOferta(Map<String, dynamic> ofertaData) async {
    final data = await _apiService.post('/ofertas', ofertaData);
    return Oferta.fromJson(data);
  }

  // Mostrar detalles de una oferta específica
  Future<Oferta> getOferta(int id) async {
    final data = await _apiService.get('/ofertas/$id');
    return Oferta.fromJson(data);
  }

  // Actualizar datos de una oferta
  Future<Oferta> updateOferta(int id, Map<String, dynamic> ofertaData) async {
    final data = await _apiService.put('/ofertas/$id', ofertaData);
    return Oferta.fromJson(data);
  }

  // Eliminar una oferta
  Future<void> deleteOferta(int id) async {
    await _apiService.delete('/ofertas/$id');
  }

  // Obtener ofertas activas
  Future<List<Oferta>> getOfertasActivas() async {
    final data = await _apiService.get('/ofertas/activas');
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  }


  // Extender la fecha de expiración de una oferta
  Future<Oferta> extendExpiracion(int id, String nuevaFechaExpiracion) async {
    final data = await _apiService.put('/ofertas/$id/extend', {
      'nueva_fecha_expiracion': nuevaFechaExpiracion,
    });
    return Oferta.fromJson(data['oferta']);
  }
    // Obtener todas las ofertas relacionadas con una producción
Future<List<Oferta>> getOfertasByProduccionId(int produccionId) async {
  try {
    final data = await _apiService.get('/produccions/$produccionId/ofertas');
    print("Respuesta de API para producción $produccionId: $data");
    return (data as List).map((json) => Oferta.fromJson(json)).toList();
  } catch (e) {
    print("Error al obtener ofertas para producción $produccionId: $e");
    rethrow;
  }
}

}
