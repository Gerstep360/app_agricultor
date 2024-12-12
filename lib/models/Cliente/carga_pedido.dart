// lib/models/Cliente/carga_pedido.dart

class Carga_pedidos {
  final int id;
  final int cantidad_asignada;
  final String estado;

  Carga_pedidos({
    required this.id,
    required this.cantidad_asignada,
    required this.estado,
  });

  factory Carga_pedidos.fromJson(Map<String, dynamic> json) {
    return Carga_pedidos(
      id: json['id'],
      cantidad_asignada: int.parse(json['cantidad_asignada']),
      estado:json['estado']
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad_asignada':cantidad_asignada,
      'estado':estado
    };
  }
}
