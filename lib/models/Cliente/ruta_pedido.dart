// lib/models/Cliente/ruta_pedido.dart

class Ruta_pedido {
  final int id;
  final DateTime fecha_entrega;
  final int capacidad_utilizada;
  final int distancia_total;
  final String estado;

  Ruta_pedido({
    required this.id,
    required this.fecha_entrega,
    required this.capacidad_utilizada,
    required this.distancia_total,
    required this.estado,
  });

  factory Ruta_pedido.fromJson(Map<String, dynamic> json) {
    return Ruta_pedido(
        id: json['id'],
        fecha_entrega: DateTime.parse(json['fecha_entrega']),
        capacidad_utilizada:
            int.tryParse(json['capacidad_utilizada'].toString()) ?? 0,
        distancia_total:
            int.tryParse(json['distancia_total'].toString()) ?? 0,
        estado: json['estado']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_entrega': fecha_entrega,
      'capacidad_utilizada': capacidad_utilizada,
      'distancia_total': distancia_total,
      'estado': estado
    };
  }
}
