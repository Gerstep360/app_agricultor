// services/Agricultor/agricultor_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/agricultor.dart';
import '/models/Agricultor/terreno.dart';
import '/models/Agricultor/produccion.dart';

class AgricultorService {
  final ApiService _apiService;

  AgricultorService(this._apiService);

  // Obtener todos los agricultores
  Future<List<Agricultor>> getAgricultores() async {
    final data = await _apiService.get('/agricultors');
    return (data as List).map((json) => Agricultor.fromJson(json)).toList();
  }

  // Crear un nuevo agricultor
  Future<Agricultor> createAgricultor(Map<String, dynamic> agricultorData) async {
    final data = await _apiService.post('/agricultors', agricultorData);
    return Agricultor.fromJson(data);
  }

  // Mostrar detalles de un agricultor específico
  Future<Agricultor> getAgricultor(int id) async {
    final data = await _apiService.get('/agricultors/$id');
    return Agricultor.fromJson(data);
  }

  // Actualizar datos de un agricultor
  Future<Agricultor> updateAgricultor(int id, Map<String, dynamic> agricultorData) async {
    final data = await _apiService.put('/agricultors/$id', agricultorData);
    return Agricultor.fromJson(data);
  }

  // Eliminar un agricultor
  Future<void> deleteAgricultor(int id) async {
    await _apiService.delete('/agricultors/$id');
  }

  // Obtener los terrenos del agricultor
  Future<List<Terreno>> getTerrenos(int agricultorId) async {
    final data = await _apiService.get('/agricultors/$agricultorId/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  // Obtener las producciones del agricultor
  Future<List<Produccion>> getProducciones(int agricultorId) async {
    final data = await _apiService.get('/agricultors/$agricultorId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }
}
