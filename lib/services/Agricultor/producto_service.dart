// services/producto_service.dart
import '/services/api_service.dart';
import '/models/Agricultor/producto.dart';
import '/models/Agricultor/produccion.dart';

class ProductoService {
  final ApiService _apiService;

  ProductoService(this._apiService);

  // Obtener todos los productos
  Future<List<Producto>> getProductos() async {
    final data = await _apiService.get('/productos');
    return (data as List).map((json) => Producto.fromJson(json)).toList();
  }

  // Crear un nuevo producto
  Future<Producto> createProducto(Map<String, dynamic> productoData) async {
    final data = await _apiService.post('/productos', productoData);
    return Producto.fromJson(data);
  }

  // Mostrar detalles de un producto específico
  Future<Producto> getProducto(int id) async {
    final data = await _apiService.get('/productos/$id');
    return Producto.fromJson(data);
  }

  // Actualizar datos de un producto
  Future<Producto> updateProducto(int id, Map<String, dynamic> productoData) async {
    final data = await _apiService.put('/productos/$id', productoData);
    return Producto.fromJson(data);
  }

  // Eliminar un producto
  Future<void> deleteProducto(int id) async {
    await _apiService.delete('/productos/$id');
  }

  // Obtener todas las producciones relacionadas con un producto
  Future<List<Produccion>> getProducciones(int productoId) async {
    final data = await _apiService.get('/productos/$productoId/producciones');
    return (data as List).map((json) => Produccion.fromJson(json)).toList();
  }
}
