import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_welcome_page.dart'; // Importa la nueva página

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSuccessDialog(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text('Inicio de sesión exitoso.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWelcomePage(userName: userName)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo iniciar sesión: $message'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('http://34.202.178.210:3000/api/users/login'); // Reemplaza con tu URL
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'correo': email,
          'contrasena': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final String token = responseBody['token'];

        // Get user info
        final userInfoUrl = Uri.parse('http://34.202.178.210:3000/api/users/email/$email');
        final userInfoResponse = await http.get(
          userInfoUrl,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (userInfoResponse.statusCode == 200) {
          final user = json.decode(userInfoResponse.body);
          final String userName = user['nombreCompleto'];
          _showSuccessDialog(context, userName);
        } else {
          _showErrorDialog(context, 'No se pudo obtener la información del usuario');
        }
      } else {
        _showErrorDialog(context, response.body);
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(context, 'Error de red o del servidor');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el cuerpo
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        title: const Text('Iniciar sesión'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80), // Ajusta el espacio superior
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 80, color: Colors.blue),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email), // Icono de email
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock), // Icono de candado
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: true, // Añadir lógica para gestionar este estado
                        onChanged: (bool? value) {},
                        activeColor: Color(0xFF27AE60),
                      ),
                      Text('Recordarme'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27AE60), // Color de fondo del botón verde
                      foregroundColor: Colors.white, // Color del texto del botón blanco
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Ajusta el padding del botón
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Botón más redondeado
                      ),
                    ),
                    child: const Text('INICIAR'),
                  ),
                  const SizedBox(height: 20), // Espacio adicional para separar el botón de los comentarios
                  TextButton(
                    onPressed: () {}, // Añadir lógica para recuperar contraseña
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
