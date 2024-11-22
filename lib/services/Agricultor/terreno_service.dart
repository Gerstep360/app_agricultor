// services/terreno_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/terreno.dart';
import '/models/Agricultor/produccion.dart';

class TerrenoService {
  final ApiService _apiService;

  TerrenoService(this._apiService);

  // Obtener todos los terrenos
  Future<List<Terreno>> getTerrenos() async {
    final data = await _apiService.get('/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  // Crear un nuevo terreno
  Future<Terreno> createTerreno(Map<String, dynamic> terrenoData) async {
    final data = await _apiService.post('/terrenos', terrenoData);
    return Terreno.fromJson(data);
  }

  // Mostrar detalles de un terreno específico
  Future<Terreno> getTerreno(int id) async {
    final data = await _apiService.get('/terrenos/$id');
    return Terreno.fromJson(data);
  }

  // Actualizar datos de un terreno
  Future<Terreno> updateTerreno(int id, Map<String, dynamic> terrenoData) async {
    final data = await _apiService.put('/terrenos/$id', terrenoData);
    return Terreno.fromJson(data);
  }

  // Eliminar un terreno
  Future<void> deleteTerreno(int id) async {
    await _apiService.delete('/terrenos/$id');
  }

  // Obtener todas las producciones relacionadas con un terreno específico
  Future<List<Produccion>> getProducciones(int terrenoId) async {
    final data = await _apiService.get('/terrenos/$terrenoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }

    // Obtener todos los terrenos de un agricultor
  Future<List<Terreno>> getTerrenosByAgricultorId(int agricultorId) async {
    final data = await _apiService.get('/agricultors/$agricultorId/terrenos');
    return (data as List).map((json) => Terreno.fromJson(json)).toList();
  }

  //Terrenos
  
}
