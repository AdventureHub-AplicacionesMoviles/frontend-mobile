import 'package:flutter/material.dart';
import 'package:frontend/models/season.dart';
import 'package:frontend/services/season_service.dart';

class SeasonProvider extends ChangeNotifier {
  final service = SeasonService();

  List<Season> _seasons = [];
  List<Season> get seasons => _seasons;
  set trips(List<Season> value) {
    _seasons = value;
    notifyListeners();
  }

  List<Season> _filteredSeasons = [];
  List<Season> get filteredSeasons => _filteredSeasons;
  set filteredTrips(List<Season> filteredSeasons) {
    _filteredSeasons = filteredSeasons;
    notifyListeners();
  }

  Future<void> getSeasons(String? token) async {
    try {
      _seasons = await service.getSeasons(token);
      _filteredSeasons = _seasons;
      return;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  void resetData() {
    _seasons = [];
    _filteredSeasons = [];
    notifyListeners();
  }
}
