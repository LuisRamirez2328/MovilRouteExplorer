import 'package:flutter/material.dart';
import 'interest_zones_page.dart'; // Importa la página de zonas de interés
import 'search_routes_page.dart'; // Importa la nueva página

class HomeWelcomePage extends StatelessWidget {
  final String userName;

  const HomeWelcomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el cuerpo
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.account_circle, size: 40, color: Colors.black),
                SizedBox(width: 8),
                Text(userName, style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
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
                      // Navegar a la página de buscar rutas
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
                            'assets/bus.png', // Ruta de tu imagen
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
                      // Navegar a la página de Zonas de interés
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
                            'assets/places.png', // Ruta de tu imagen
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Zonas de interés', style: TextStyle(fontSize: 16, color: Colors.black)),
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
