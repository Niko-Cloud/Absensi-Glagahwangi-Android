import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entity/map.dart';
import '../model/map_model.dart';

class MapRepository {
  LatLng geofenceCenter = const LatLng(-7.6481967, 110.6633733);
  double geofenceRadius = 10.0;

  Future<void> initializeGeofenceRadius() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('map')
          .doc('radius_document')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        MapModel mapModel = MapModel.fromFirestore(snapshot);
        MapEntity mapEntity = mapModel.toEntity();

        geofenceRadius = mapEntity.geofenceRadius;
        geofenceCenter = mapEntity.geofenceCenter;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing geofence radius: $e');
      }
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<LatLng> getCurrentLatLng() async {
    Position position = await getCurrentLocation();
    return LatLng(position.latitude, position.longitude);
  }

  Future<String> getLocationName(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    return "${placemark.name}, ${placemark.street} ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, lat:${position.latitude}, long:${position.longitude}";
  }

  Future<double> getDistanceFromGeofence(Position position) async {
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      geofenceCenter.latitude,
      geofenceCenter.longitude,
    );
  }

  Marker getCurrentLocationMarker(LatLng currentLatLng, String locationName) {
    return Marker(
      markerId: const MarkerId('currentLocation'),
      position: currentLatLng,
      infoWindow: InfoWindow(title: 'My Location', snippet: locationName),
    );
  }

  Circle getGeofenceCircle() {
    return Circle(
      circleId: const CircleId('geofence'),
      center: geofenceCenter,
      radius: geofenceRadius,
      fillColor: Colors.blue.withOpacity(0.1),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
  }
}
