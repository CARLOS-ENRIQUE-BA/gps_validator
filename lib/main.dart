import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationChecker(),
    );
  }
}

class LocationChecker extends StatefulWidget {
  @override
  _LocationCheckerState createState() => _LocationCheckerState();
}

class _LocationCheckerState extends State<LocationChecker> {
  String _gpsStatus = "Desconocido";
  bool _isMockLocation = false;

  @override
  void initState() {
    super.initState();
    _checkGPSStatus();
  }

  Future<void> _checkGPSStatus() async {
    // Verificar si el GPS está habilitado
    loc.Location location = loc.Location();
    bool isGpsEnabled = await location.serviceEnabled();
    
    if (!isGpsEnabled) {
      setState(() {
        _gpsStatus = "GPS Deshabilitado";
      });
      return;
    }
    
    // Verificar si la ubicación es una ubicación simulada
    Position position = await Geolocator.getCurrentPosition();
    bool isMockLocation = position.isMocked ?? false;

    setState(() {
      _isMockLocation = isMockLocation;
      _gpsStatus = isMockLocation ? "Ubicación Falsa" : "Ubicación Real";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del GPS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Estado de la ubicación: $_gpsStatus',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGPSStatus,
              child: Text('Verificar GPS nuevamente'),
            ),
          ],
        ),
      ),
    );
  }
}
