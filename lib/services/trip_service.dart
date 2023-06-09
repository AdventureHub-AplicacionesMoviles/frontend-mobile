import 'package:frontend/models/filter.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/trip_item.dart';
import 'package:frontend/services/api_service.dart';

String buildFilterEndpoint(String baseEndpoint, Filter filters) {
  final params = filters.toJson();
  final nonNullParams = params.entries.where((entry) => entry.value != null);
  final query =
      nonNullParams.map((entry) => '${entry.key}=${entry.value}').join('&');
  final encodedQuery = Uri.encodeFull(query);
  return '$baseEndpoint?$encodedQuery';
}

class TripService {
  Future<List<Trip>> getTrips(String? token, Filter? filters) async {
    print("Getting trips");
    if (filters != null) {
      print(filters.toJson());
    }

    final headers = {'Authorization': 'Bearer $token'};
    const baseEndpoint = '/trips';
    final endpoint = filters != null
        ? buildFilterEndpoint(baseEndpoint, filters)
        : baseEndpoint;
    final response = await ApiService.get(endpoint, headers);
    return (response as List).map((data) => Trip.fromJson(data)).toList();
  }

  Future<TripItem> getTripById(String? token, int id) async {
    final headers = {'Authorization': 'Bearer $token'};
    final endpoint = '/trips/${id.toString()}';
    final response = await ApiService.get(endpoint, headers);
    return TripItem.fromJson(response);
  }

  Future<List<Trip>> getTripsByRoleViaToken(
      String? token, Filter? filters) async {
    final headers = {'Authorization': 'Bearer $token'};
    const baseEndpoint = "/trips/my-trips";
    final endpoint = filters != null
        ? buildFilterEndpoint(baseEndpoint, filters)
        : baseEndpoint;
    final response = await ApiService.get(endpoint, headers);
    return (response as List).map((data) => Trip.fromJson(data)).toList();
  }
}
