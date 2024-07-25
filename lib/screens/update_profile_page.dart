import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class UpdateProfilePage extends StatefulWidget {
  final String userId;
  final String token;

  const UpdateProfilePage({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final url = Uri.parse('http://34.202.178.210:3000/api/users/${widget.userId}');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        _nameController.text = userData['nombreCompleto'];
        _emailController.text = userData['correo'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Perfil'),
        backgroundColor: Color(0xFF27AE60),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _getImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.add_a_photo, size: 50) : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Actualizar Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27AE60),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              child: Text('Eliminar Cuenta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    final url = Uri.parse('http://34.202.178.210:3000/api/users/${widget.userId}');

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer ${widget.token}';

    if (_nameController.text.isNotEmpty) {
      request.fields['nombreCompleto'] = _nameController.text;
    }
    if (_emailController.text.isNotEmpty) {
      request.fields['correo'] = _emailController.text;
    }
    if (_passwordController.text.isNotEmpty) {
      request.fields['contrasena'] = _passwordController.text;
    }

    if (_image != null) {
      print('File path: ${_image!.path}');
      print('File name: ${path.basename(_image!.path)}');
      print('File size: ${await _image!.length()} bytes');

      final mimeType = lookupMimeType(_image!.path);
      print('MIME type: $mimeType');

      request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType.parse(mimeType ?? 'image/jpeg')
      ));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado con éxito')),
      );
      Navigator.pop(context, _nameController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil: $responseBody')),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cuenta'),
          content: Text('¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final url = Uri.parse('http://34.202.178.210:3000/api/users/${widget.userId}');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cuenta eliminada con éxito')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la cuenta: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red al intentar eliminar la cuenta')),
      );
    }
  }
}
