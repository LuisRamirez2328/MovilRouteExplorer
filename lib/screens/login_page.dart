import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSuccessDialog(BuildContext context, String userName, String userId, String token) {
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
                  MaterialPageRoute(
                    builder: (context) => HomeWelcomePage(
                      userName: userName,
                      userId: userId,
                      token: token,
                    ),
                  ),
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
      final url = Uri.parse('http://34.202.178.210:3000/api/users/login');
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
          final String userId = user['id'].toString();
          _showSuccessDialog(context, userName, userId, token);
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
      backgroundColor: Colors.white,
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
                  const SizedBox(height: 80),
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
                      prefixIcon: Icon(Icons.email),
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
                      prefixIcon: Icon(Icons.lock),
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
                        value: true,
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
                      backgroundColor: Color(0xFF27AE60),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('INICIAR'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
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