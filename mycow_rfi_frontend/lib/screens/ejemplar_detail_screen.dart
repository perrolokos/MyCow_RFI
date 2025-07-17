import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/models/clasificacion.dart';
import 'package:mycow_rfi_frontend/services/ejemplar_service.dart';

class EjemplarDetailScreen extends StatefulWidget {
  final int ejemplarId;

  const EjemplarDetailScreen({super.key, required this.ejemplarId});

  @override
  State<EjemplarDetailScreen> createState() => _EjemplarDetailScreenState();
}

class _EjemplarDetailScreenState extends State<EjemplarDetailScreen> {
  Ejemplar? _ejemplar;
  List<Clasificacion> _clasificaciones = [];
  String? _qrCodeUrl;

  @override
  void initState() {
    super.initState();
    _loadEjemplarDetails();
  }

  Future<void> _loadEjemplarDetails() async {
    try {
      String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      final ejemplarService = EjemplarService(token);

      // Obtener el ejemplar (puedes añadir un método getEjemplarById en EjemplarService si no lo tienes)
      // Por ahora, asumiremos que puedes obtenerlo de la lista o pasar el objeto completo.
      // Para simplificar, aquí solo cargaremos las clasificaciones y el QR.

      _clasificaciones = await ejemplarService.getHistorialClasificaciones(widget.ejemplarId);
      _qrCodeUrl = await ejemplarService.generateQrCode(widget.ejemplarId);

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar detalles del ejemplar: $e')),
      );
    }
  }

  void _generatePdf() async {
    try {
      String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      final ejemplarService = EjemplarService(token);
      String message = await ejemplarService.generatePdfReport(widget.ejemplarId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Ejemplar')),
      body: _ejemplar == null && _clasificaciones.isEmpty && _qrCodeUrl == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Información del Ejemplar (puedes añadirla aquí si la pasas o la cargas)
                  // Text('Nombre: ${_ejemplar?.nombre ?? 'Cargando...'}'),
                  // Text('Raza: ${_ejemplar?.raza ?? 'Cargando...'}'),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generatePdf,
                    child: const Text('Generar Reporte PDF'),
                  ),
                  const SizedBox(height: 10),
                  if (_qrCodeUrl != null)
                    Center(
                      child: Column(
                        children: [
                          const Text('Código QR:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Image.network(
                            _qrCodeUrl!,
                            width: 200,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) => const Text('Error al cargar QR'),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text('Historial de Clasificaciones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _clasificaciones.isEmpty
                      ? const Text('No hay clasificaciones históricas.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _clasificaciones.length,
                          itemBuilder: (context, index) {
                            final clasificacion = _clasificaciones[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Fecha: ${clasificacion.fechaClasificacion.toLocal().toString().split(' ')[0]}'),
                                    Text('Puntaje Final: ${clasificacion.puntajeFinal.toStringAsFixed(2)}'),
                                    const Text('Detalles:'),
                                    ...clasificacion.datosClasificacion.entries.map((entry) => Text('  ${entry.key}: ${entry.value}')),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}