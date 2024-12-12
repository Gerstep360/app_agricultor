// lib/models/Cliente/pedidos.dart

class Pedidos {
  final int id;
  final DateTime fecha_entrega;
  final double ubicacion_longitud;
  final double ubicacion_latitud;
  final String estado;

  Pedidos({
    required this.id,
    required this.fecha_entrega,
    required this.ubicacion_longitud,
    required this.ubicacion_latitud,
    required this.estado,
  });

  factory Pedidos.fromJson(Map<String, dynamic> json) {
    return Pedidos(
      id: json['id'],
      fecha_entrega: DateTime.parse(json['fecha_entrega']),
      ubicacion_longitud: double.tryParse(json['ubicacion_longitud'].toString()) ?? 0.0,
      ubicacion_latitud: double.tryParse(json['ubicacion_latitud'].toString()) ?? 0.0,
      estado:json['estado']
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_entrega':fecha_entrega,
      'ubicacion_longitud':ubicacion_longitud,
      'ubicacion_latitud':ubicacion_latitud,
      'estado':estado
    };
  }
}

