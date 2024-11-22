// models/producto.dart

class Producto {
  final int id;
  final int idCategoria;
  final String nombre;
  final String? descripcion;

  Producto({
    required this.id,
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      idCategoria: json['id_categoria'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
