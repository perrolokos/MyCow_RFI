import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/services/ejemplar_service.dart';
import 'package:mycow_rfi_frontend/services/clasificacion_service.dart';

class ClasificacionFormScreen extends StatefulWidget {
  const ClasificacionFormScreen({super.key});

  @override
  State<ClasificacionFormScreen> createState() => _ClasificacionFormScreenState();
}

class _ClasificacionFormScreenState extends State<ClasificacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Ejemplar? _selectedEjemplar;
  List<Ejemplar> _ejemplares = [];
  Map<String, dynamic> _parametrosRaza = {};
  Map<String, TextEditingController> _scoreControllers = {};
  double _puntajeFinal = 0.0;

  @override
  void initState() {
    super.initState();
    _loadEjemplares();
  }

  Future<void> _loadEjemplares() async {
    try {
      String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      final ejemplarService = EjemplarService(token);
      _ejemplares = await ejemplarService.getEjemplares();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ejemplares: $e')),
      );
    }
  }

  Future<void> _loadParametrosPorRaza(String raza) async {
    try {
      String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      final clasificacionService = ClasificacionService(token);
      _parametrosRaza = await clasificacionService.getParametrosPorRaza(raza);
      _scoreControllers.clear();
      if (_parametrosRaza.containsKey('parametros') && _parametrosRaza['parametros'].containsKey('categorias')) {
        for (var categoria in _parametrosRaza['parametros']['categorias']) {
          _scoreControllers[categoria['nombre']] = TextEditingController();
        }
      }
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar parámetros de raza: $e')),
      );
    }
  }

  void _calculateFinalScore() {
    if (_parametrosRaza.isEmpty || !_parametrosRaza.containsKey('parametros') || !_parametrosRaza['parametros'].containsKey('categorias')) {
      setState(() {
        _puntajeFinal = 0.0;
      });
      return;
    }

    double totalScore = 0.0;
    double totalWeight = 0.0;

    for (var categoria in _parametrosRaza['parametros']['categorias']) {
      String categoryName = categoria['nombre'];
      double categoryWeight = categoria['peso'].toDouble();

      if (_scoreControllers.containsKey(categoryName) && _scoreControllers[categoryName]!.text.isNotEmpty) {
        double score = double.tryParse(_scoreControllers[categoryName]!.text) ?? 0.0;
        totalScore += (score * categoryWeight);
        totalWeight += categoryWeight;
      }
    }

    setState(() {
      _puntajeFinal = totalWeight > 0 ? totalScore / totalWeight : 0.0;
    });
  }

  void _saveClasificacion() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedEjemplar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un ejemplar.')),
        );
        return;
      }
      if (_parametrosRaza.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, carga los parámetros de clasificación.')),
        );
        return;
      }

      Map<String, dynamic> datosClasificacion = {};
      _scoreControllers.forEach((key, controller) {
        datosClasificacion[key] = double.tryParse(controller.text) ?? 0.0;
      });

      try {
        String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
        final clasificacionService = ClasificacionService(token);
        await clasificacionService.createClasificacion({
          'ejemplar_id': _selectedEjemplar!.id,
          'fecha_clasificacion': DateTime.now().toIso8601String().split('T').first,
          'datos_clasificacion': datosClasificacion,
          'puntaje_final': _puntajeFinal,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clasificación guardada con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar clasificación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Clasificación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Ejemplar>(
                value: _selectedEjemplar,
                hint: const Text('Selecciona un Ejemplar'),
                onChanged: (Ejemplar? newValue) {
                  setState(() {
                    _selectedEjemplar = newValue;
                    if (newValue != null) {
                      _loadParametrosPorRaza(newValue.raza);
                    } else {
                      _parametrosRaza = {};
                      _scoreControllers.clear();
                      _puntajeFinal = 0.0;
                    }
                  });
                },
                items: _ejemplares.map<DropdownMenuItem<Ejemplar>>((Ejemplar ejemplar) {
                  return DropdownMenuItem<Ejemplar>(
                    value: ejemplar,
                    child: Text('${ejemplar.nombre} (${ejemplar.raza})'),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona un ejemplar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_parametrosRaza.isNotEmpty && _parametrosRaza.containsKey('parametros') && _parametrosRaza['parametros'].containsKey('categorias'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Categorías de Clasificación:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...(_parametrosRaza['parametros']['categorias'] as List).map((categoria) {
                      String categoryName = categoria['nombre'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _scoreControllers[categoryName],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${categoryName} (Peso: ${categoria['peso']}%)',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa un puntaje';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Ingresa un número válido';
                            }
                            return null;
                          },
                          onChanged: (_) => _calculateFinalScore(),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Text(
                      'Puntaje Final Ponderado: ${_puntajeFinal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveClasificacion,
                child: const Text('Guardar Clasificación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}