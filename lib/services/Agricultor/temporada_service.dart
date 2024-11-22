// services/temporada_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/temporada.dart';
import '/models/Agricultor/produccion.dart';

class TemporadaService {
  final ApiService _apiService;

  TemporadaService(this._apiService);

  // Obtener todas las temporadas
  Future<List<Temporada>> getTemporadas() async {
    final data = await _apiService.get('/temporadas');
    return (data as List).map((json) => Temporada.fromJson(json)).toList();
  }

  // Crear una nueva temporada
  Future<Temporada> createTemporada(Map<String, dynamic> temporadaData) async {
    final data = await _apiService.post('/temporadas', temporadaData);
    return Temporada.fromJson(data);
  }

  // Mostrar detalles de una temporada específica
  Future<Temporada> getTemporada(int id) async {
    final data = await _apiService.get('/temporadas/$id');
    return Temporada.fromJson(data);
  }

  // Actualizar datos de una temporada
  Future<Temporada> updateTemporada(int id, Map<String, dynamic> temporadaData) async {
    final data = await _apiService.put('/temporadas/$id', temporadaData);
    return Temporada.fromJson(data);
  }

  // Eliminar una temporada
  Future<void> deleteTemporada(int id) async {
    await _apiService.delete('/temporadas/$id');
  }

  // Obtener todas las producciones de una temporada
  Future<List<Produccion>> getProducciones(int temporadaId) async {
    final data = await _apiService.get('/temporadas/$temporadaId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }
}
