// models/temporada.dart

class Temporada {
  final int id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String? descripcion;

  Temporada({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    this.descripcion,
  });

  factory Temporada.fromJson(Map<String, dynamic> json) {
    return Temporada(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'descripcion': descripcion,
    };
  }
}
