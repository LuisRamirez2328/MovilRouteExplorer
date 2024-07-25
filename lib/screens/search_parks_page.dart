import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchParksPage extends StatefulWidget {
  const SearchParksPage({super.key});

  @override
  _SearchParksPageState createState() => _SearchParksPageState();
}

class _SearchParksPageState extends State<SearchParksPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  List<String> comments = [];
  List<String> routes = [];

  // Datos de ejemplo para los parques y rutas
  final Map<String, List<String>> parksAndRoutes = {
    'Parque de la Marimba': ['Ruta1', 'Ruta2'],
    'Parque Central': ['Ruta3', 'Ruta4'],
    'Parque Joyyo Mayu': ['Ruta5', 'Ruta6'],
  };

  final Map<String, List<LatLng>> routeCoordinates = {
    'Ruta1': [
      LatLng(16.734300, -93.056682),
      LatLng(16.769177, -93.194823)
    ],
    'Ruta2': [
      LatLng(16.730369, -93.120352),
      LatLng(16.751798, -93.104289),
    ],
    'Ruta3': [
      LatLng(16.751798, -93.104289),
      LatLng(16.7593, -93.1161),
    ],
    'Ruta4': [
      LatLng(16.7550, -93.1200),
      LatLng(16.7600, -93.1300),
    ],
    'Ruta5': [
      LatLng(16.7600, -93.1300),
      LatLng(16.7700, -93.1400),
    ],
    'Ruta6': [
      LatLng(16.7700, -93.1400),
      LatLng(16.7800, -93.1500),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el cuerpo
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        title: const Text('Buscar parques'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: 'Buscar parques',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _searchPark(_searchController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27AE60),
                  foregroundColor: Colors.white,
                ),
                child: Text('Buscar'),
              ),
              const SizedBox(height: 20),
              _buildRoutesList(),
              const SizedBox(height: 20),
              _buildMapContainer(),
              const SizedBox(height: 20),
              _buildCommentsSection(),
              const SizedBox(height: 10),
              _buildCommentField(),
              const SizedBox(height: 10),
              _buildCommentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutesList() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFD5E8D4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'Rutas que pasan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          if (routes.isEmpty)
            const Text(
              'No se encontraron rutas para este parque.',
              style: TextStyle(fontSize: 14, color: Colors.black),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _searchRoute(routes[index]),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      routes[index],
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFFD5E8D4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(16.7569, -93.1292),
            zoom: 12,
          ),
          polylines: _polylines,
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comentarios',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comments[index],
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editComment(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteComment(index),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: 'Añadir un comentario',
        filled: true,
        fillColor: Colors.grey[200],
      ),
      maxLines: 3,
    );
  }

  Widget _buildCommentButton() {
    return ElevatedButton(
      onPressed: _addComment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF27AE60),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text('Enviar comentario'),
    );
  }

  void _searchPark(String parkName) {
    setState(() {
      routes = parksAndRoutes[parkName] ?? [];
      _polylines.clear();
      _markers.clear();
    });
  }

  void _searchRoute(String routeName) async {
    if (routeName.isEmpty || !routeCoordinates.containsKey(routeName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ruta no encontrada. Por favor, ingrese una ruta válida.')),
      );
      return;
    }

    final points = routeCoordinates[routeName]!;
    final directions = await _getDirections(points);

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: directions,
          width: 5,
        ),
      );

      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('start'),
          position: points.first,
          infoWindow: InfoWindow(title: 'Inicio de la ruta'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: points.last,
          infoWindow: InfoWindow(title: 'Fin de la ruta'),
        ),
      );
    });

    _animateToBounds(directions);
  }

  Future<void> _animateToBounds(List<LatLng> points) async {
    final GoogleMapController controller = await _controller.future;
    final LatLngBounds bounds = _getBounds(points);
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;
    for (LatLng point in points) {
      minLat = minLat == null ? point.latitude : (point.latitude < minLat ? point.latitude : minLat);
      maxLat = maxLat == null ? point.latitude : (point.latitude > maxLat ? point.latitude : maxLat);
      minLng = minLng == null ? point.longitude : (point.longitude < minLng ? point.longitude : minLng);
      maxLng = maxLng == null ? point.longitude : (point.longitude > maxLng ? point.longitude : maxLng);
    }
    return LatLngBounds(southwest: LatLng(minLat!, minLng!), northeast: LatLng(maxLat!, maxLng!));
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  void _editComment(int index) {
    _commentController.text = comments[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar comentario'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              labelText: 'Editar comentario',
              filled: true,
              fillColor: Colors.grey[200],
            ),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                setState(() {
                  comments[index] = _commentController.text;
                });
                Navigator.of(context).pop();
                _commentController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteComment(int index) {
    setState(() {
      comments.removeAt(index);
    });
  }

  Future<List<LatLng>> _getDirections(List<LatLng> points) async {
    const apiKey = 'AIzaSyDqSiJrLj0W6SIreNs9oKu-Do6F-xm9CGw';  // Reemplaza con tu API key real
    final origin = '${points.first.latitude},${points.first.longitude}';
    final destination = '${points.last.latitude},${points.last.longitude}';

    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=AIzaSyDqSiJrLj0W6SIreNs9oKu-Do6F-xm9CGw'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        List<LatLng> routePoints = [];
        for (var step in data['routes'][0]['legs'][0]['steps']) {
          routePoints.add(LatLng(
              step['end_location']['lat'], step['end_location']['lng']));
        }
        return routePoints;
      }
    }
    return points;
  }
}
