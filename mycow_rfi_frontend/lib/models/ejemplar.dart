class Ejemplar {
  final int id;
  final String codigoArete;
  final String? foto;
  final String nombre;
  final DateTime fechaNacimiento;
  final String raza;

  Ejemplar({
    required this.id,
    required this.codigoArete,
    this.foto,
    required this.nombre,
    required this.fechaNacimiento,
    required this.raza,
  });

  factory Ejemplar.fromJson(Map<String, dynamic> json) {
    return Ejemplar(
      id: json['id'],
      codigoArete: json['codigo_arete'],
      foto: json['foto'],
      nombre: json['nombre'],
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
      raza: json['raza'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo_arete': codigoArete,
      'foto': foto,
      'nombre': nombre,
      'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'raza': raza,
    };
  }
}