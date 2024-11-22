import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:geolocator/geolocator.dart';

class MapLocationPicker extends StatefulWidget {
  final void Function(latlng.LatLng) onLocationSelected;

  const MapLocationPicker({
    Key? key,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  latlng.LatLng? _currentLocation;
  bool _isLoading = true;
  
  String? _formattedCoordinates;

  @override
  void initState() {
    super.initState();
    _initializeCurrentLocation();
  }

  Future<void> _initializeCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("Permiso de ubicación denegado");
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = latlng.LatLng(position.latitude, position.longitude);
        _formattedCoordinates = "Latitud: ${position.latitude.toStringAsFixed(6)}, Longitud: ${position.longitude.toStringAsFixed(6)}";
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener la ubicación actual: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapTap(latlng.LatLng position) {
    setState(() {
      _currentLocation = position;
      _formattedCoordinates = "Latitud: ${position.latitude.toStringAsFixed(6)}, Longitud: ${position.longitude.toStringAsFixed(6)}";
    });
  }

void _onConfirm() {
  if (_currentLocation != null) {
    widget.onLocationSelected(_currentLocation!);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Selecciona una ubicación en el mapa")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Ubicación"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onConfirm,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_formattedCoordinates != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _formattedCoordinates!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _currentLocation ?? latlng.LatLng(0, 0),
                      initialZoom: 15.0,
                      onTap: (tapPosition, point) => _onMapTap(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        width: 40.0,
                        height: 40.0,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
