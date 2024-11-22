// models/Agriculot/oferta.dart

class Oferta {
  final int id;
  final int idProduccion;
  final DateTime fechaCreacion;
  final DateTime fechaExpiracion;
  final String estado;

  Oferta({
    required this.id,
    required this.idProduccion,
    required this.fechaCreacion,
    required this.fechaExpiracion,
    required this.estado,
  });

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: json['id'],
      idProduccion: json['id_produccion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaExpiracion: DateTime.parse(json['fecha_expiracion']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_produccion': idProduccion,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_expiracion': fechaExpiracion.toIso8601String(),
      'estado': estado,
    };
  }
}
