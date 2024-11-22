// services/produccion_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/produccion.dart';

class ProduccionService {
  final ApiService _apiService;

  ProduccionService(this._apiService);

  // Obtener todas las producciones
  Future<List<Produccion>> getProducciones() async {
    final data = await _apiService.get('/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Crear una nueva producción
  Future<Produccion> createProduccion(Map<String, dynamic> produccionData) async {
    final data = await _apiService.post('/producciones', produccionData);
    return Produccion.fromJson(data);
  }

  // Mostrar detalles de una producción específica
  Future<Produccion> getProduccion(int id) async {
    final data = await _apiService.get('/producciones/$id');
    return Produccion.fromJson(data);
  }

  // Actualizar datos de una producción
  Future<Produccion> updateProduccion(int id, Map<String, dynamic> produccionData) async {
    final data = await _apiService.put('/producciones/$id', produccionData);
    return Produccion.fromJson(data);
  }

  // Eliminar una producción
  Future<void> deleteProduccion(int id) async {
    await _apiService.delete('/producciones/$id');
  }

  // Obtener producciones activas
  Future<List<Produccion>> getProduccionesActivas() async {
    final data = await _apiService.get('/producciones/activas');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener todas las producciones relacionadas con un terreno
  Future<List<Produccion>> getProduccionesByTerrenoId(int terrenoId) async {
    final data = await _apiService.get('/terrenos/$terrenoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por terreno
  Future<List<Produccion>> getProduccionesByTerreno(int terrenoId) async {
    final data = await _apiService.get('/producciones/terreno/$terrenoId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por temporada
  Future<List<Produccion>> getProduccionesByTemporada(int temporadaId) async {
    final data = await _apiService.get('/producciones/temporada/$temporadaId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

  // Obtener producciones por producto
  Future<List<Produccion>> getProduccionesByProducto(int productoId) async {
    final data = await _apiService.get('/producciones/producto/$productoId');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }
}
