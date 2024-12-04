// lib/models/Agricultor/oferta_detalle.dart

class OfertaDetalle {
  final int? id;
  final int? idOferta; // Hacer que sea opcional
  final int idUnidadMedida;
  final int idMoneda;
  final int idProduccion;
  final String? descripcion;
  final double cantidadFisico;
  final double? cantidadComprometido;
  final double precio;
  final double? precioUnitario;
  final String estado;

  OfertaDetalle({
    this.id,
    this.idOferta,
    required this.idUnidadMedida,
    required this.idMoneda,
    required this.idProduccion,
    this.descripcion,
    required this.cantidadFisico,
    this.cantidadComprometido,
    required this.precio,
    this.precioUnitario,
    required this.estado,
  });

  factory OfertaDetalle.fromJson(Map<String, dynamic> json) {
    return OfertaDetalle(
      id: json['id'],
      idOferta: json['id_oferta'],
      idUnidadMedida: json['id_unidadmedida'],
      idMoneda: json['id_moneda'],
      idProduccion: json['id_produccion'],
      descripcion: json['descripcion'],
      cantidadFisico: double.tryParse(json['cantidad_fisico'].toString()) ?? 0.0,
      cantidadComprometido: json['cantidad_comprometido'] != null
          ? double.tryParse(json['cantidad_comprometido'].toString())
          : null,
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      precioUnitario: json['preciounitario'] != null
          ? double.tryParse(json['preciounitario'].toString())
          : null,
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id_oferta': idOferta,
      'id_produccion': idProduccion,
      'id_unidadmedida': idUnidadMedida,
      'id_moneda': idMoneda,
      'descripcion': descripcion ?? '',
      'cantidad_fisico': cantidadFisico,
      'precio': precio,
      'estado': estado,
    };
    if (cantidadComprometido != null) {
      data['cantidad_comprometido'] = cantidadComprometido;
    }
    if (precioUnitario != null) {
      data['preciounitario'] = precioUnitario;
    }
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  OfertaDetalle copyWith({int? idOferta}) {
    return OfertaDetalle(
      id: this.id,
      idOferta: idOferta ?? this.idOferta,
      idUnidadMedida: this.idUnidadMedida,
      idMoneda: this.idMoneda,
      idProduccion: this.idProduccion,
      descripcion: this.descripcion,
      cantidadFisico: this.cantidadFisico,
      cantidadComprometido: this.cantidadComprometido,
      precio: this.precio,
      precioUnitario: this.precioUnitario,
      estado: this.estado,
    );
  }
}
