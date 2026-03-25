import 'package:flutter_test/flutter_test.dart';
import 'package:product_versus_app/models/product.dart';
import 'package:product_versus_app/providers/product_provider.dart';

void main() {
  group('ProductProvider Tests', () {
    late ProductProvider provider;

    setUp(() {
      provider = ProductProvider();
    });

    test('Initial state should be empty', () {
      expect(provider.products, isEmpty);
      expect(provider.isLoading, false);
    });

    test('Comparison list operations', () {
      final product = Product(
        name: "Test Product",
        description: "Desc",
        ref: "123",
        image: "img",
        price: 10.0,
        provider: "Prov",
        categoryLevel1: "Cat1",
        categoryLevel2: "Cat2",
        categoryLevel3: "Cat3",
        inStock: true,
        lat: -18.1496,
        lng: 49.4023,
      );

      provider.addToCompare(product);
      expect(provider.comparisonList.length, 1);
      expect(provider.isInCompare(product), true);

      provider.removeFromCompare(product);
      expect(provider.comparisonList.length, 0);
      expect(provider.isInCompare(product), false);
    });
  });
}
