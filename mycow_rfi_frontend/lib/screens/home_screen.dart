import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/services/auth_service.dart';
import 'package:mycow_rfi_frontend/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      // Asume que tienes el token guardado en algún lugar (por ejemplo, SharedPreferences)
      // Por ahora, usaremos un token de ejemplo o lo pasaremos desde la pantalla de login
      // En una aplicación real, deberías persistir el token.
      String? token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      if (token != null) {
        User user = await authService.getUser(token);
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Error loading user: $e');
      // Si hay un error al cargar el usuario (ej. token inválido), redirigir al login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _logout() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      String? token = 'YOUR_AUTH_TOKEN'; // Reemplazar con el token real
      if (token != null) {
        await authService.logout(token);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCow RFI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: _currentUser == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bienvenido, ${_currentUser!.name}!',
                      style: const TextStyle(fontSize: 24)),
                  Text('Tu rol: ${_currentUser!.roleId}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ejemplares');
                    },
                    child: const Text('Gestionar Ejemplares'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/clasificar');
                    },
                    child: const Text('Realizar Clasificación'),
                  ),
                ],
              ),
      ),
    );
  }
}