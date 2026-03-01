import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

import 'dart:io';

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return "http://192.168.11.254:8000";
    }
    return "http://127.0.0.1:8000";
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/scores'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Error fetching products: $e");
      // Fallback to empty list or rethrow depending on needs
      // For now, let's return empty list to avoid crashing UI
      return [];
    }
  }

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return {};
    }
  }

  Future<String> getAdvice(List<Product> products) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/advice'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          products
              .map(
                (p) => {
                  "name": p.name,
                  "description": p.description,
                  "ref": p.ref,
                  "image": p.image,
                  "price": p.price,
                  "provider": p.provider,
                  "category_level1": p.categoryLevel1,
                  "category_level2": p.categoryLevel2,
                  "category_level3": p.categoryLevel3,
                  "in_stock": p.inStock,
                  "score": p.score,
                },
              )
              .toList(),
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['advice'];
      } else {
        throw Exception('Failed to get advice');
      }
    } catch (e) {
      print("Error getting advice: $e");
      return "Could not get advice at this time.";
    }
  }
}
