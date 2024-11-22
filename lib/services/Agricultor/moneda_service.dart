// services/moneda_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/moneda.dart';

class MonedaService {
  final ApiService _apiService;

  MonedaService(this._apiService);

  // Obtener todas las monedas
  Future<List<Moneda>> getMonedas() async {
    final data = await _apiService.get('/monedas');
    return (data as List).map((json) => Moneda.fromJson(json)).toList();
  }

  // Crear una nueva moneda
  Future<Moneda> createMoneda(Map<String, dynamic> monedaData) async {
    final data = await _apiService.post('/monedas', monedaData);
    return Moneda.fromJson(data);
  }

  // Mostrar detalles de una moneda específica
  Future<Moneda> getMoneda(int id) async {
    final data = await _apiService.get('/monedas/$id');
    return Moneda.fromJson(data);
  }

  // Actualizar datos de una moneda
  Future<Moneda> updateMoneda(int id, Map<String, dynamic> monedaData) async {
    final data = await _apiService.put('/monedas/$id', monedaData);
    return Moneda.fromJson(data);
  }

  // Eliminar una moneda
  Future<void> deleteMoneda(int id) async {
    await _apiService.delete('/monedas/$id');
  }
}
