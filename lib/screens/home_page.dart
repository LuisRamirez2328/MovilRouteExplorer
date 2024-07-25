import 'package:flutter/material.dart';
import 'signup_page.dart'; // Importa la nueva página
import 'login_page.dart'; // Importa la página de login

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF27AE60), // Color de fondo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'Route explorer',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Facilitando la movilidad, una ruta a la vez',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/buss.png', // Ruta correcta
              height: 200,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navega a la página de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Color de fondo del botón
                foregroundColor: Colors.black, // Color del texto del botón
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('INICIAR'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navega a la página de creación de cuenta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text(
                'No tienes una cuenta?',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
