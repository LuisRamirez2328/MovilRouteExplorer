import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SearchRoutesPage extends StatefulWidget {
  const SearchRoutesPage({Key? key}) : super(key: key);

  @override
  _SearchRoutesPageState createState() => _SearchRoutesPageState();
}
class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  TextEditingController _searchController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  List<String> comments = [];
  final String googleMapsApiKey = 'AIzaSyDqSiJrLj0W6SIreNs9oKu-Do6F-xm9CGw';

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
    'Ruta6': [
      LatLng(16.751051, -93.116685),
      LatLng(16.757780, -93.088229),
    ],
    'Ruta7': [
      LatLng(16.7545, -93.1150),
      LatLng(16.7590, -93.1390),
    ],
    'Ruta8': [
      LatLng(16.7498,-93.1028),
      LatLng(16.768697, -93.130184),
    ],
    'Ruta9': [
      LatLng(16.750661, -93.119836),
      LatLng(16.768697, -93.130184),
    ],
    'Ruta11': [
      LatLng(16.725846, -93.101111),
      LatLng(16.748601, -93.117102),
    ],
    'Ruta12': [
      LatLng(16.724812, -93.092132),
      LatLng(16.749373, -93.116123),
    ],
    'Ruta13': [
      LatLng(16.750802, -93.114950),
      LatLng(16.784716, -93.112498),
    ],
    'Ruta14': [
      LatLng(16.7510, -93.1045),
      LatLng(16.748741, -93.082468),
    ],
    'Ruta15': [
      LatLng(16.726439, -93.118245),
      LatLng(16.748725, -93.117960),
    ],
    'Ruta16': [
      LatLng(16.749736, -93.113418),
      LatLng(16.763503, -93.072797),
    ],
    'Ruta17': [
      LatLng(16.7540,  -93.1155),
      LatLng(16.761462, -93.073070),
    ],
    'Ruta18': [
      LatLng(16.7515,  -93.1050),
      LatLng(16.760100, -93.069674),
    ],
    'Ruta19': [
      LatLng(16.747626, -93.116376),
      LatLng(16.736804, -93.108660),
    ],
    'Ruta20': [
      LatLng(16.760208, -93.126799),
      LatLng(16.744977, -93.105558),
    ],
    'Ruta21': [
      LatLng(16.750653, -93.113658),
      LatLng(16.771409, -93.099573),
    ],
    'Ruta22': [
      LatLng( 16.7510,  -93.1045),
      LatLng(16.763485, -93.074180),
    ],
    'Ruta23': [
      LatLng(16.749276, -93.115765),
      LatLng(16.758577, -93.070450),
    ],
    'Ruta24': [
      LatLng(16.7540,  -93.1155),
      LatLng(16.780498, -93.089116),
    ],
    'Ruta25': [
      LatLng(16.742956, -93.155563),
      LatLng(16.753488, -93.082398),
    ],
    'Ruta26': [
      LatLng(16.738680, -93.125816),
      LatLng(16.7545,  -93.1120),
    ],
    'Ruta27': [
      LatLng(16.738680, -93.125816),
      LatLng(16.7545,  -93.1120),
    ],
    'Ruta28': [
      LatLng(16.741977, -93.088736),
      LatLng(16.749618, -93.116035),
    ],
    'Ruta29': [
      LatLng(16.7505, -93.1040),
      LatLng(16.780063, -93.094423),
    ],
    'Ruta30': [
      LatLng(16.7505,-93.1040),
      LatLng(16.796964, -93.101502),
    ],
    'Ruta31': [
      LatLng(16.748956, -93.119637),
      LatLng(16.790500, -93.123921),
    ],
    'Ruta32': [
      LatLng(16.7500, -93.1045),
      LatLng(16.7540, -93.1180),
    ],
    'Ruta33': [
      LatLng(16.748715, -93.117955),
      LatLng(16.728987, -93.067326),
    ],
    'Ruta34': [
      LatLng(16.750419, -93.155946),
      LatLng(16.748606, -93.117094),
    ],
    'Ruta35': [
      LatLng(16.772110, -93.164848),
      LatLng(16.744113, -93.104192),
    ],
    'Ruta37': [
      LatLng(16.750779, -93.114669),
      LatLng(16.793699, -93.092399),
    ],
    'Ruta39': [
      LatLng(16.7545, -93.1150),
      LatLng(16.731702, -93.084484),
    ],
    'Ruta40': [
      LatLng(16.738494, -93.073931),
      LatLng(16.748662, -93.115399),
    ],
    'Ruta41': [
      LatLng(16.7510, -93.1045),
      LatLng(16.734132, -93.099412),
    ],
    'Ruta42': [
      LatLng(16.7505,  -93.1040),
      LatLng(16.778466, -93.116334),
    ],
    'Ruta43': [
      LatLng(16.7535,  -93.1200),
      LatLng(16.7580, -93.1170),
    ],
    'Ruta44': [
      LatLng(16.749417, -93.116973),
      LatLng(16.729350, -93.076776),
    ],
    'Ruta45': [
      LatLng(16.749299, -93.120522),
      LatLng(16.734704, -93.158227),
    ],
    'Ruta46': [
      LatLng( 16.7540, -93.1045),
      LatLng(16.760387, -93.079919),
    ],
    'Ruta47': [
      LatLng( 16.750667, -93.114213),
      LatLng(16.770077, -93.075725),
    ],
    'Ruta48': [
      LatLng( 16.772113, -93.164821),
      LatLng(16.750673, -93.114220),
    ],
    'Ruta49': [
      LatLng(16.7500,  -93.1045),
      LatLng(16.784768, -93.090159),
    ],
    'Ruta50': [
      LatLng(16.7510, -93.1045),
      LatLng(16.769854, -93.080076),
    ],
    'Ruta51': [
      LatLng(16.744991, -93.066660),
      LatLng(16.7590,  -93.1165),
    ],
    'Ruta52': [
      LatLng(16.753565, -93.082863),
      LatLng(16.781506, -93.210136),
    ],
    'Ruta53': [
      LatLng(16.788475, -93.214042),
      LatLng(16.750041, -93.080926),
    ],
    'Ruta54': [
      LatLng(16.7545, -93.1060),
      LatLng(16.800109, -93.110650),
    ],
    'Ruta55': [
      LatLng(16.750986, -93.119259),
      LatLng(16.768472, -93.130548),
    ],
    'Ruta56': [
      LatLng(16.760477, -93.072910),
      LatLng(16.748098, -93.118085),
    ],
    'Ruta57': [
      LatLng(16.748552, -93.116267),
      LatLng(16.784888, -93.113841),
    ],
    'Ruta58': [
      LatLng(16.759740, -93.174731),
      LatLng(16.774114, -93.081482),
    ],
    'Ruta59': [
      LatLng(16.7545,-93.1060),
      LatLng(16.794624, -93.102691),
    ],
    'Ruta60': [
      LatLng(16.7540,-93.1065),
      LatLng(16.722765, -93.090221),
    ],
    'Ruta61': [
      LatLng(16.7505,-93.1045),
      LatLng(16.788488, -93.092956),
    ],
    'Ruta62': [
      LatLng(16.7540, -93.1065),
      LatLng(16.793016, -93.104710),
    ],
    'Ruta63': [
      LatLng(16.772503, -93.080517),
      LatLng(16.772634, -93.080518),
    ],
    'Ruta64': [
      LatLng(16.733224, -93.101280),
      LatLng(16.753713, -93.123770),
    ],
    'Ruta65': [
      LatLng(16.738064, -93.137903),
      LatLng( 16.7541, -93.1058),
    ],
    'Ruta66': [
      LatLng(16.768118, -93.164429),
      LatLng( 16.7515, -93.1050),
    ],
    'Ruta67': [
      LatLng(16.7540,-93.1065),
      LatLng(16.730030, -93.187565),
    ],
    'Ruta68': [
      LatLng(16.7505,-93.1040),
      LatLng(16.789251, -93.107005),
    ],
    'Ruta69': [
      LatLng(16.737276, -93.121700),
      LatLng(16.7490,  -93.1145),
    ],
    'Ruta70': [
      LatLng(16.749552, -93.072483),
      LatLng(16.751439, -93.115760),
    ],
    'Ruta71': [
      LatLng(16.747913, -93.118136),
      LatLng(16.730272, -93.187870),
    ],
    'Ruta72': [
      LatLng(16.7510, -93.1045),
      LatLng(16.778520, -93.085738),
    ],
    'Ruta73': [
      LatLng(16.7510, -93.1045),
      LatLng(16.778520, -93.085738),
    ],

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF27AE60),
        elevation: 0,
        title: const Text('Buscar rutas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildSearchField(),
              const SizedBox(height: 10),
              _buildSearchButton(),
              const SizedBox(height: 20),
              _buildDetailsContainer(),
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: 'Buscar ruta (Ruta1, Ruta2, etc.)',
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onSubmitted: (value) => _searchRoute(value),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: () => _searchRoute(_searchController.text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF27AE60),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text('Buscar'),
    );
  }

  Widget _buildDetailsContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD5E8D4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: const [
                Text(
                  'Detalles de la ruta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text('Punto ida', style: TextStyle(fontSize: 14, color: Colors.black)),
                Text('Punto de salida', style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD5E8D4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: const [
                Text(
                  'Horario',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text('Entra a las 6 am', style: TextStyle(fontSize: 14, color: Colors.black)),
                Text('Sale a las 10 pm', style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
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
            print('Mapa creado');
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

  void _searchRoute(String routeName) async {
    if (routeName.isEmpty || !routeCoordinates.containsKey(routeName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ruta no encontrada. Por favor, ingrese Ruta1, Ruta2, etc.')),
      );
      return;
    }

    final points = routeCoordinates[routeName]!;
    final List<LatLng> polylineCoordinates = await _getRoutePolyline(points[0], points[1]);
    polylineCoordinates.addAll(points.reversed);
    _setPolylines(polylineCoordinates);
    _addMarkers(points);
  }

  Future<List<LatLng>> _getRoutePolyline(LatLng start, LatLng end) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=AIzaSyDqSiJrLj0W6SIreNs9oKu-Do6F-xm9CGw';

    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['routes'].isNotEmpty) {
      final List<LatLng> polylineCoordinates = [];
      final List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];

      for (var step in steps) {
        polylineCoordinates.add(LatLng(
          step['start_location']['lat'],
          step['start_location']['lng'],
        ));
        polylineCoordinates.add(LatLng(
          step['end_location']['lat'],
          step['end_location']['lng'],
        ));
      }

      return polylineCoordinates;
    } else {
      return [];
    }
  }

  void _setPolylines(List<LatLng> points) {
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          color: Colors.red,
          points: points,
          width: 5,
        ),
      );
    });

    _animateToBounds(points);
  }

  void _addMarkers(List<LatLng> points) {
    setState(() {
      _markers.clear();
      for (int i = 0; i < points.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId('marker_$i'),
            position: points[i],
            infoWindow: InfoWindow(title: 'Punto de interés $i'),
          ),
        );
      }
    });
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
}
