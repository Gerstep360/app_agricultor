// lib/models/Cliente/cliente.dart

class Cliente {
  final int? id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String password;
  final String direccion;
  final String? tokendevice;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.password,
    required this.direccion,
    this.tokendevice,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono:json['telefono'],
      password: json['password'], // Campo agregado
      direccion: json['direccion'],
      tokendevice: json['tokendevice']
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'password': password,
      'direccion': direccion,
      'tokendevice': tokendevice,
    };
  }
}

