import 'package:flutter/material.dart';
import 'package:frontend/models/destination.dart';
import 'package:frontend/services/destination.service.dart';

class DestinationProvider extends ChangeNotifier {
  final service = DestinationService();

  List<Destination> _destinations = [];
  List<Destination> get destinations => _destinations;
  set trips(List<Destination> value) {
    _destinations = value;
    notifyListeners();
  }

  List<Destination> _filteredDestinations = [];
  List<Destination> get filteredDestinations => _filteredDestinations;
  set filteredTrips(List<Destination> filteredDestinations) {
    _filteredDestinations = filteredDestinations;
    notifyListeners();
  }

  // Future<void> getDetination(String? token) async {
  //   try {
  //     _destinations = await service.getDestinations(token);
  //     _filteredDestinations = _destinations;
  //     return;
  //   } catch (e) {
  //     throw Exception('Failed to load data');
  //   }
  // }

  void resetData() {
    _destinations = [];
    _filteredDestinations = [];
    notifyListeners();
  }
}
