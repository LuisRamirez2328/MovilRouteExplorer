import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'interest_zones_page.dart';
import 'search_routes_page.dart';
import 'update_profile_page.dart';

class HomeWelcomePage extends StatefulWidget {
  final String userName;
  final String userId;
  final String token;

  const HomeWelcomePage({
    Key? key,
    required this.userName,
    required this.userId,
    required this.token
  }) : super(key: key);

  @override
  _HomeWelcomePageState createState() => _HomeWelcomePageState();
}

class _HomeWelcomePageState extends State<HomeWelcomePage> {
  late String _userName;
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final url = Uri.parse('http://34.202.178.210:3000/api/users/${widget.userId}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _userName = userData['nombreCompleto'];
          _userImageUrl = userData['image'];
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        title: const Text('Rutas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfilePage(
                      userId: widget.userId,
                      token: widget.token,
                    ),
                  ),
                );
                if (result != null) {
                  _loadUserData();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: _userImageUrl != null
                        ? NetworkImage(_userImageUrl!)
                        : null,
                    child: _userImageUrl == null
                        ? Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 8),
                  Text(_userName, style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hola bienvenido a\nRoute Explorer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchRoutesPage()),
                      );
                    },
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5E8D4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/bus.png',
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Visualizar rutas', style: TextStyle(fontSize: 16, color: Colors.black)),
                          const Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InterestZonesPage()),
                      );
                    },
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5E8D4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/places.png',
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Zonas de interes', style: TextStyle(fontSize: 16, color: Colors.black)),
                          const Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}