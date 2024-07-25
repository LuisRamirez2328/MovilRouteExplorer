import 'package:flutter/material.dart';
import 'search_parks_page.dart';
import 'search_restaurants_page.dart';
import 'search_schools_page.dart';

class InterestZonesPage extends StatelessWidget {
  const InterestZonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el cuerpo
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        title: const Text('Zonas de interés'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Zonas de interés',
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
                      // Navegar a la página de Buscar Parques
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchParksPage()),
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
                            'assets/park.png', // Ruta de tu imagen
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Parques', style: TextStyle(fontSize: 16, color: Colors.black)),
                          const Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navegar a la página de Buscar Restaurantes
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchRestaurantsPage()),
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
                            'assets/restaurant.png', // Ruta de tu imagen
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Restaurantes', style: TextStyle(fontSize: 16, color: Colors.black)),
                          const Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navegar a la página de Buscar Escuelas
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchSchoolsPage()),
                      );
                    },
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5E8D4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/school.png', // Ruta de tu imagen
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text('Escuelas', style: TextStyle(fontSize: 16, color: Colors.black)),
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
