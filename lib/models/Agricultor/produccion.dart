class Produccion {
  final int id;
  final int id_terreno;
  final int id_temporada;
  final int id_producto;
  final int idUnidadMedida;
  final String descripcion;
  final double cantidad;
  final DateTime fechaCosecha;
  final DateTime fechaExpiracion;
  final String estado;

  Produccion({
    required this.id,
    required this.id_terreno,
    required this.id_temporada,
    required this.id_producto,
    required this.idUnidadMedida,
    required this.descripcion,
    required this.cantidad,
    required this.fechaCosecha,
    required this.fechaExpiracion,
    required this.estado,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) {
    return Produccion(
      id: json['id'],
      id_terreno: json['id_terreno'],
      id_temporada: json['id_temporada'],
      id_producto: json['id_producto'],
      idUnidadMedida: json['id_unidadmedida'],
      descripcion: json['descripcion'],
      cantidad: double.tryParse(json['cantidad'].toString()) ?? 0.0,
      fechaCosecha: DateTime.parse(json['fecha_cosecha']),
      fechaExpiracion:  DateTime.parse(json['fecha_expiracion']),
      estado: json['estado']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_terreno': id_terreno,
      'id_temporada': id_temporada,
      'id_producto': id_producto,
      'id_unidadmedida': idUnidadMedida,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'fecha_cosecha': fechaCosecha.toIso8601String(),
      'fecha_expiracion': fechaExpiracion.toIso8601String(),
      'estado': estado
    };
  }
}
