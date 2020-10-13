import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;

void main() {
  runApp(MyMap());
}

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController _googleMapController;
  final lat_lng = const LatLng(11.8046901, 13.1943973);
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY MAP',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Offices'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          mapType: MapType.satellite,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: const LatLng(0, 0), zoom:2.0),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
