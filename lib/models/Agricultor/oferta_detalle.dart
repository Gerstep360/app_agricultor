class OfertaDetalle {
  final int id;
  final int idOferta;
  final int idUnidadMedida;
  final int idMoneda;
  final int idProduccion;
  final String? descripcion;
  final double cantidadFisico;
  final double? cantidadComprometido;
  final double precio;
  final double? precioUnitario; // Añadir este campo
  final String estado;

  OfertaDetalle({
    required this.id,
    required this.idProduccion,
    required this.idOferta,
    required this.idUnidadMedida,
    required this.idMoneda,
    this.descripcion,
    required this.cantidadFisico,
    this.cantidadComprometido,
    required this.precio,
    this.precioUnitario, // Añadir este campo al constructor
    required this.estado,
  });

  factory OfertaDetalle.fromJson(Map<String, dynamic> json) {
    return OfertaDetalle(
      id: json['id'],
      idProduccion: json['id_produccion'],
      idOferta: json['id_oferta'],
      idUnidadMedida: json['id_unidadmedida'],
      idMoneda: json['id_moneda'],
      descripcion: json['descripcion'],
      cantidadFisico: double.tryParse(json['cantidad_fisico'].toString()) ?? 0.0,
      cantidadComprometido: json['cantidad_comprometido'] != null
          ? double.tryParse(json['cantidad_comprometido'].toString())
          : null,
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      precioUnitario: json['preciounitario'] != null
          ? double.tryParse(json['preciounitario'].toString())
          : null, // Convertir el campo del JSON
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produccion': idProduccion,
      'id_oferta': idOferta,
      'id_unidadmedida': idUnidadMedida,
      'id_moneda': idMoneda,
      'descripcion': descripcion ?? '',
      'cantidad_fisico': cantidadFisico,
      'cantidad_comprometido': cantidadComprometido ?? 0, // Valor predeterminado
      'precio': precio,
      'preciounitario': precio / cantidadFisico, // Cálculo del precio unitario
      'estado': estado,
    };
  }
}
