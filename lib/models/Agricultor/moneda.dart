// models/moneda.dart

class Moneda {
  final int id;
  final String nombre;

  Moneda({
    required this.id,
    required this.nombre,
  });

  factory Moneda.fromJson(Map<String, dynamic> json) {
    return Moneda(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
