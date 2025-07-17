class Clasificacion {
  final int id;
  final int ejemplarId;
  final DateTime fechaClasificacion;
  final Map<String, dynamic> datosClasificacion;
  final double puntajeFinal;

  Clasificacion({
    required this.id,
    required this.ejemplarId,
    required this.fechaClasificacion,
    required this.datosClasificacion,
    required this.puntajeFinal,
  });

  factory Clasificacion.fromJson(Map<String, dynamic> json) {
    return Clasificacion(
      id: json['id'],
      ejemplarId: json['ejemplar_id'],
      fechaClasificacion: DateTime.parse(json['fecha_clasificacion']),
      datosClasificacion: json['datos_clasificacion'],
      puntajeFinal: json['puntaje_final'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ejemplar_id': ejemplarId,
      'fecha_clasificacion': fechaClasificacion.toIso8601String().split('T').first,
      'datos_clasificacion': datosClasificacion,
      'puntaje_final': puntajeFinal,
    };
  }
}