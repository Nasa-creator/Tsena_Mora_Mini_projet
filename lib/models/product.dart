import 'package:google_maps_flutter/google_maps_flutter.dart';

class Product {
  final String name;
  final String description;
  final String ref;
  final String image;
  final double price;
  final String provider;
  final String categoryLevel1;
  final String categoryLevel2;
  final String categoryLevel3;
  final bool inStock;
  final double score;
  final double lat;
  final double lng;

  Product({
    required this.name,
    required this.description,
    required this.ref,
    required this.image,
    required this.price,
    required this.provider,
    required this.categoryLevel1,
    required this.categoryLevel2,
    required this.categoryLevel3,
    required this.inStock,
    this.score = 0.0,
    required this.lat,
    required this.lng,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ref: json['ref'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      provider: json['provider'] ?? '',
      categoryLevel1: json['category_level1'] ?? '',
      categoryLevel2: json['category_level2'] ?? '',
      categoryLevel3: json['category_level3'] ?? '',
      inStock: json['in_stock'] ?? false,
      score: (json['score'] ?? 0).toDouble(),
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  //juste Antananarivo si rien
  LatLng get location {
    if (lat != 0.0 && lng != 0.0) return LatLng(lat, lng);
    return const LatLng(-18.870945, 47.512343);
  }
}
