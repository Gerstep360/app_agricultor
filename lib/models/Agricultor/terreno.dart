class Terreno {
  final int id;
  final int idAgricultor;
  final String descripcion;
  final double area;
  final double superficieTotal;
  final double ubicacionLatitud;
  final double ubicacionLongitud;

  Terreno({
    required this.id,
    required this.idAgricultor,
    required this.descripcion,
    required this.area,
    required this.superficieTotal,
    required this.ubicacionLatitud,
    required this.ubicacionLongitud,
  });

  factory Terreno.fromJson(Map<String, dynamic> json) {
    return Terreno(
      id: json['id'],
      idAgricultor: json['id_agricultor'],
      descripcion: json['descripcion'],
      area: double.tryParse(json['area'].toString()) ?? 0.0,
      superficieTotal:
          double.tryParse(json['superficie_total'].toString()) ?? 0.0,
      ubicacionLatitud:
          double.tryParse(json['ubicacion_latitud'].toString()) ?? 0.0,
      ubicacionLongitud:
          double.tryParse(json['ubicacion_longitud'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_agricultor': idAgricultor,
      'descripcion': descripcion,
      'area': area,
      'superficie_total': superficieTotal,
      'ubicacion_latitud': ubicacionLatitud,
      'ubicacion_longitud': ubicacionLongitud,
    };
  }
}
