// services/unidad_medida_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/unidad_medida.dart';

class UnidadMedidaService {
  final ApiService _apiService;

  UnidadMedidaService(this._apiService);

  // Obtener todas las unidades de medida
  Future<List<UnidadMedida>> getUnidadMedidas() async {
    final data = await _apiService.get('/unidad_medidas');
    return (data as List).map((json) => UnidadMedida.fromJson(json)).toList();
  }

  // Crear una nueva unidad de medida
  Future<UnidadMedida> createUnidadMedida(Map<String, dynamic> unidadData) async {
    final data = await _apiService.post('/unidad_medidas', unidadData);
    return UnidadMedida.fromJson(data);
  }

  // Mostrar detalles de una unidad de medida específica
  Future<UnidadMedida> getUnidadMedida(int id) async {
    final data = await _apiService.get('/unidad_medidas/$id');
    return UnidadMedida.fromJson(data);
  }

  // Actualizar datos de una unidad de medida
  Future<UnidadMedida> updateUnidadMedida(int id, Map<String, dynamic> unidadData) async {
    final data = await _apiService.put('/unidad_medidas/$id', unidadData);
    return UnidadMedida.fromJson(data);
  }

  // Eliminar una unidad de medida
  Future<void> deleteUnidadMedida(int id) async {
    await _apiService.delete('/unidad_medidas/$id');
  }
}
