import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mycow_rfi_frontend/services/auth_service.dart';
import 'package:mycow_rfi_frontend/services/ejemplar_service.dart';
import 'package:mycow_rfi_frontend/screens/login_screen.dart';
import 'package:mycow_rfi_frontend/screens/register_screen.dart';
import 'package:mycow_rfi_frontend/screens/home_screen.dart';
import 'package:mycow_rfi_frontend/screens/ejemplar_list_screen.dart';
import 'package:mycow_rfi_frontend/screens/ejemplar_form_screen.dart';
import 'package:mycow_rfi_frontend/screens/clasificacion_form_screen.dart';
import 'package:mycow_rfi_frontend/screens/ejemplar_detail_screen.dart';
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/services/clasificacion_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        // EjemplarService requiere un token, lo pasaremos a través de argumentos o un estado global
        // Por ahora, se inicializará con un token de ejemplo. En una app real, se gestionaría el token.
        Provider<EjemplarService>(create: (_) => EjemplarService('YOUR_AUTH_TOKEN')), // Reemplazar con el token real
        Provider<ClasificacionService>(create: (_) => ClasificacionService('YOUR_AUTH_TOKEN')), // Reemplazar con el token real
      ],
      child: MaterialApp(
        title: 'MyCow RFI App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/ejemplares': (context) => const EjemplarListScreen(),
          '/ejemplares/create': (context) => const EjemplarFormScreen(),
          '/ejemplares/edit': (context) {
            final ejemplar = ModalRoute.of(context)!.settings.arguments as Ejemplar;
            return EjemplarFormScreen(ejemplar: ejemplar);
          },
          '/ejemplares/detail': (context) {
            final ejemplarId = ModalRoute.of(context)!.settings.arguments as int;
            return EjemplarDetailScreen(ejemplarId: ejemplarId);
          },
          '/clasificar': (context) => const ClasificacionFormScreen(),
        },
      ),
    );
  }
}