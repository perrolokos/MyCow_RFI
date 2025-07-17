import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/services/ejemplar_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EjemplarFormScreen extends StatefulWidget {
  final Ejemplar? ejemplar;

  const EjemplarFormScreen({super.key, this.ejemplar});

  @override
  State<EjemplarFormScreen> createState() => _EjemplarFormScreenState();
}

class _EjemplarFormScreenState extends State<EjemplarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoAreteController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  DateTime? _fechaNacimiento;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.ejemplar != null) {
      _codigoAreteController.text = widget.ejemplar!.codigoArete;
      _nombreController.text = widget.ejemplar!.nombre;
      _razaController.text = widget.ejemplar!.raza;
      _fechaNacimiento = widget.ejemplar!.fechaNacimiento;
      // No se carga la imagen existente directamente aquí, solo se muestra la URL si existe.
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _saveEjemplar() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaNacimiento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona la fecha de nacimiento.')),
        );
        return;
      }

      try {
        String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
        final ejemplarService = EjemplarService(token);

        final newEjemplar = Ejemplar(
          id: widget.ejemplar?.id ?? 0, // Usar 0 o un valor temporal si es nuevo
          codigoArete: _codigoAreteController.text,
          foto: widget.ejemplar?.foto, // Mantener la foto existente si no se cambia
          nombre: _nombreController.text,
          fechaNacimiento: _fechaNacimiento!,
          raza: _razaController.text,
        );

        if (widget.ejemplar == null) {
          // Crear nuevo ejemplar
          await ejemplarService.createEjemplar(newEjemplar, imageFile: _imageFile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ejemplar creado con éxito')),
          );
        } else {
          // Actualizar ejemplar existente
          await ejemplarService.updateEjemplar(newEjemplar, imageFile: _imageFile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ejemplar actualizado con éxito')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar ejemplar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ejemplar == null ? 'Crear Ejemplar' : 'Editar Ejemplar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codigoAreteController,
                decoration: const InputDecoration(labelText: 'Código de Arete'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el código de arete';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _razaController,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la raza';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  _fechaNacimiento == null
                      ? 'Seleccionar Fecha de Nacimiento'
                      : 'Fecha de Nacimiento: ${(_fechaNacimiento!).toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Seleccionar Foto'),
              ),
              if (_imageFile != null)
                Image.file(_imageFile!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover),
              if (widget.ejemplar != null && widget.ejemplar!.foto != null && _imageFile == null)
                Image.network(
                  'http://127.0.0.1:8000/storage/${widget.ejemplar!.foto}', // Asegúrate de que esta URL sea correcta
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEjemplar,
                child: const Text('Guardar Ejemplar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}