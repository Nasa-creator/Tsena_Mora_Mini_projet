import 'dart:ffi';

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final List<Product> _comparisonList = [];

  bool _isLoading = false;
  String? _selectedCategoryLevel1;
  String? _selectedCategoryLevel2;

  List<Product> get products => _filteredProducts;
  List<Product> get comparisonList => _comparisonList;
  bool get isLoading => _isLoading;
  String? get selectedCategoryLevel1 => _selectedCategoryLevel1;
  String? get selectedCategoryLevel2 => _selectedCategoryLevel2;

  int countCompare = 0;
  bool isZero = true;

  // Get unique Level 1 categories
  List<String> get categoryLevel1Options {
    return _allProducts.map((p) => p.categoryLevel1).toSet().toList();
  }

  // Get unique Level 2 categories based on selected Level 1
  List<String> get categoryLevel2Options {
    if (_selectedCategoryLevel1 == null) return [];
    return _allProducts
        .where((p) => p.categoryLevel1 == _selectedCategoryLevel1)
        .map((p) => p.categoryLevel2)
        .toSet()
        .toList();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _apiService.getProducts();
      _applyFilters();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategoryLevel1(String? category) {
    _selectedCategoryLevel1 = category;
    _selectedCategoryLevel2 =
        null; // Reset subcategory when main category changes
    _applyFilters();
    notifyListeners();
  }

  void setCategoryLevel2(String? category) {
    _selectedCategoryLevel2 = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      if (_selectedCategoryLevel1 != null &&
          product.categoryLevel1 != _selectedCategoryLevel1) {
        return false;
      }
      if (_selectedCategoryLevel2 != null &&
          product.categoryLevel2 != _selectedCategoryLevel2) {
        return false;
      }
      return true;
    }).toList();
  }

  void addToCompare(Product product) {
    if (!_comparisonList.contains(product)) {
      _comparisonList.add(product);
      countCompare++;
      isZero = false;
      notifyListeners();
    }
  }

  void removeFromCompare(Product product) {
    _comparisonList.remove(product);
    countCompare--;
    if (countCompare <= 0) {
      isZero = true;
      countCompare = 0; // Ensure it doesn't go negative
    }
    notifyListeners();
  }

  void clearComparison() {
    _comparisonList.clear();
    countCompare = 0;
    isZero = true;
    notifyListeners();
  }

  bool isInCompare(Product product) {
    return _comparisonList.contains(product);
  }

  Future<String> getAdvice() async {
    return await _apiService.getAdvice(_comparisonList);
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
