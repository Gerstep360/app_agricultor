class Agricultor {
  final int id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String direccion;
  final String? informacionBancaria;
  final String nit;
  final String carnet;
  final String? licenciaFuncionamiento;
  final String estado;
  final String? token;
  final String? password; // Campo agregado

  Agricultor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.direccion,
    this.password, // Campo agregado
    this.informacionBancaria,
    required this.nit,
    required this.carnet,
    this.licenciaFuncionamiento,
    required this.estado,
    required this.token,
    
  });

  factory Agricultor.fromJson(Map<String, dynamic> json) {
    return Agricultor(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      password: json['password'], // Campo agregado
      informacionBancaria: json['informacion_bancaria'],
      nit: json['nit'],
      carnet: json['carnet'],
      licenciaFuncionamiento: json['licencia_funcionamiento'],
      estado: json['estado'],
      token: json['tokendevice'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'password': password, // Campo agregado
      'informacion_bancaria': informacionBancaria,
      'nit': nit,
      'carnet': carnet,
      'licencia_funcionamiento': licenciaFuncionamiento,
      'estado': estado,
      'tokendevice': token,

    };
  }
}
