import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/services/ejemplar_service.dart';

class EjemplarListScreen extends StatefulWidget {
  const EjemplarListScreen({super.key});

  @override
  State<EjemplarListScreen> createState() => _EjemplarListScreenState();
}

class _EjemplarListScreenState extends State<EjemplarListScreen> {
  late Future<List<Ejemplar>> _ejemplaresFuture;

  @override
  void initState() {
    super.initState();
    _loadEjemplares();
  }

  void _loadEjemplares() {
    // En una aplicación real, el token debería venir de un estado global o almacenamiento seguro.
    // Por ahora, usaremos un token de ejemplo.
    String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
    final ejemplarService = EjemplarService(token);
    _ejemplaresFuture = ejemplarService.getEjemplares();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Ejemplares'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/ejemplares/create').then((_) => _loadEjemplares());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Ejemplar>>(
        future: _ejemplaresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay ejemplares registrados.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ejemplar = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: ejemplar.foto != null
                        ? Image.network(
                            'http://127.0.0.1:8000/storage/${ejemplar.foto}', // Asegúrate de que esta URL sea correcta
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(ejemplar.nombre),
                    subtitle: Text('Código: ${ejemplar.codigoArete} - Raza: ${ejemplar.raza}'),
                    onTap: () {
                      Navigator.pushNamed(context, '/ejemplares/detail', arguments: ejemplar.id)
                          .then((_) => _loadEjemplares());
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(context, '/ejemplares/edit', arguments: ejemplar)
                                .then((_) => _loadEjemplares());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            // Implementar lógica de eliminación
                            bool? confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar Eliminación'),
                                  content: Text('¿Estás seguro de que quieres eliminar a ${ejemplar.nombre}?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              try {
                                String token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
                                final ejemplarService = EjemplarService(token);
                                await ejemplarService.deleteEjemplar(ejemplar.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ejemplar eliminado con éxito')),
                                );
                                _loadEjemplares(); // Recargar la lista
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al eliminar ejemplar: $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}