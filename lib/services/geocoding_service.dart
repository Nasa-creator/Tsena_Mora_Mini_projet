import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static const apiKey = "VOTRE_CLE_API";

  static Future<String?> getAddress(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      }
      return null;
    } catch (e) {
      print("Erreur adresse: $e");
      return null;
    }
  }

  static Future<LatLng?> getCoordinates(String placeName) async {
    final queries = [
      "KIBO Madagascar", // ← nom exact Google Maps
      "$placeName Madagascar",
      "$placeName Antananarivo Madagascar",
    ];

    for (final query in queries) {
      final encoded = Uri.encodeComponent(query);
      final url =
          "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$encoded&key=$apiKey";

      try {
        final response = await http.get(Uri.parse(url));
        final data = json.decode(response.body);

        print("=== QUERY: $query → STATUS: ${data['status']} ===");

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          print("=== TROUVÉ: ${data['results'][0]['name']} ===");
          return LatLng(location['lat'], location['lng']);
        }
      } catch (e) {
        print("=== Erreur: $e ===");
      }
    }

    print("=== AUCUN RÉSULTAT pour: $placeName ===");
    return null;
  }
}
