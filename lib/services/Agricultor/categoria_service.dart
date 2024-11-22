// services/categoria_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/categoria.dart';
import '/models/Agricultor/producto.dart';

class CategoriaService {
  final ApiService _apiService;

  CategoriaService(this._apiService);

  // Obtener todas las categorías
  Future<List<Categoria>> getCategorias() async {
    final data = await _apiService.get('/categorias');
    return (data as List).map((json) => Categoria.fromJson(json)).toList();
  }

  // Crear una nueva categoría
  Future<Categoria> createCategoria(Map<String, dynamic> categoriaData) async {
    final data = await _apiService.post('/categorias', categoriaData);
    return Categoria.fromJson(data);
  }

  // Mostrar detalles de una categoría específica
  Future<Categoria> getCategoria(int id) async {
    final data = await _apiService.get('/categorias/$id');
    return Categoria.fromJson(data);
  }

  // Actualizar datos de una categoría
  Future<Categoria> updateCategoria(int id, Map<String, dynamic> categoriaData) async {
    final data = await _apiService.put('/categorias/$id', categoriaData);
    return Categoria.fromJson(data);
  }

  // Eliminar una categoría
  Future<void> deleteCategoria(int id) async {
    await _apiService.delete('/categorias/$id');
  }

  // Obtener todos los productos de una categoría específica
  Future<List<Producto>> getProductos(int categoriaId) async {
    final data = await _apiService.get('/categorias/$categoriaId/productos');
    return (data as List).map((json) => Producto.fromJson(json)).toList();
  }
}
