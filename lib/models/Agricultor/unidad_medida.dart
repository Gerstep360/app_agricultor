  // models/unidad_medida.dart

  class UnidadMedida {
    final int id;
    final String nombre;

    UnidadMedida({
      required this.id,
      required this.nombre,
    });

    factory UnidadMedida.fromJson(Map<String, dynamic> json) {
      return UnidadMedida(
        id: json['id'],
        nombre: json['nombre'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'nombre': nombre,
      };
    }
  }
