// models/Agricultor/carga_oferta.dart
class CargaOferta {
  final int id;
  final int idOfertaDetalle;
  final double pesoKg;
  final double precio;
  final String estado;

  // Constructor
  CargaOferta({
    required this.id,
    required this.idOfertaDetalle,
    required this.pesoKg,
    required this.precio,
    required this.estado,
  });

  // Método para convertir un JSON en un objeto CargaOferta
factory CargaOferta.fromJson(Map<String, dynamic> json) {
  return CargaOferta(
    id: json['id'] as int,
    idOfertaDetalle: json['id_oferta_detalle'] as int,
    pesoKg: double.tryParse(json['pesokg'].toString()) ?? 0.0,
    precio: double.tryParse(json['precio'].toString()) ?? 0.0,
    estado: json['estado'] as String,
  );
}


  // Método para convertir un objeto CargaOferta en un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_oferta_detalle': idOfertaDetalle,
      'pesokg': pesoKg,
      'precio': precio,
      'estado': estado,
    };
  }
}
