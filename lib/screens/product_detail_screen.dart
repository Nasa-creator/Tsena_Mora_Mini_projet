import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    // ✅ Définir la localisation du produit pour Google Map
    final LatLng productLocation = LatLng(product.lat, product.lng);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            CachedNetworkImage(
              imageUrl: product.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                height: 300,
                child: Center(child: Icon(Icons.error, size: 50)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "MGA ${product.price.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Score: ${product.score.toStringAsFixed(1)}",
                      style: TextStyle(
                        color: Colors.amber[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Catégories
                  Text(
                    "${product.categoryLevel1} > ${product.categoryLevel2} ${product.categoryLevel3 == "__none__" ? "" : " > ${product.categoryLevel3}"}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  ExpansionTile(
                    title: const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock et provider
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          product.inStock ? "In Stock" : "Out of Stock",
                        ),
                        backgroundColor: product.inStock
                            ? Colors.green[100]
                            : Colors.red[100],
                        labelStyle: TextStyle(
                          color: product.inStock
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(label: Text("Provider: ${product.provider}")),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bouton Ajouter / Retirer de la comparaison
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final isInCompare = provider.isInCompare(product);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isInCompare) {
                              provider.removeFromCompare(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Removed from comparison"),
                                ),
                              );
                            } else {
                              provider.addToCompare(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to comparison"),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isInCompare
                                ? Icons.remove_circle_outline
                                : Icons.add_circle_outline,
                          ),
                          label: Text(
                            isInCompare
                                ? "Remove from Compare"
                                : "Add to Compare",
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: isInCompare
                                ? Colors.red[50]
                                : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            foregroundColor: isInCompare
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    },
                  ),

                  // ✅ Google Map
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: productLocation,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(product.ref),
                          position: productLocation,
                          infoWindow: InfoWindow(title: product.name),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Suggestions
                  const Text(
                    "Suggestions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final suggestions = provider.products
                          .where(
                            (p) =>
                                p.categoryLevel2 == product.categoryLevel2 &&
                                p.ref != product.ref,
                          )
                          .take(4)
                          .toList();

                      if (suggestions.isEmpty) {
                        return const Text("No suggestions available.");
                      }

                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 160,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ProductCard(product: suggestions[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button pour comparaison
      floatingActionButton: (provider.isZero)
          ? FloatingActionButton(
              mini: true,
              onPressed: () {},
              child: Icon(Icons.compare_arrows),
            )
          : Badge(
              label: Text("${provider.countCompare}"),
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/comparaison');
                },
                child: const Icon(Icons.compare_arrows),
              ),
            ),
    );
  }
}
