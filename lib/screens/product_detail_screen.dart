import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../services/geocoding_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? productAddress;

  get _providerLocation => null;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final address = await GeocodingService.getAddress(
      widget.product.location.latitude,
      widget.product.location.longitude,
    );
    setState(() {
      productAddress = address ?? "Adresse non trouvée";
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final LatLng productLocation = widget.product.location;

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            CachedNetworkImage(
              imageUrl: widget.product.image,
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
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "MGA ${widget.product.price.toStringAsFixed(2)}",
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
                      "Score: ${widget.product.score.toStringAsFixed(1)}",
                      style: TextStyle(
                        color: Colors.amber[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Catégories
                  Text(
                    "${widget.product.categoryLevel1} > ${widget.product.categoryLevel2} ${widget.product.categoryLevel3 == "__none__" ? "" : " > ${widget.product.categoryLevel3}"}",
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
                          widget.product.description,
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
                          widget.product.inStock ? "In Stock" : "Out of Stock",
                        ),
                        backgroundColor: widget.product.inStock
                            ? Colors.green[100]
                            : Colors.red[100],
                        labelStyle: TextStyle(
                          color: widget.product.inStock
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(label: Text("Provider: ${widget.product.provider}")),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bouton Ajouter / Retirer de la comparaison
                  Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final isInCompare = provider.isInCompare(widget.product);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isInCompare) {
                              provider.removeFromCompare(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Removed from comparison"),
                                ),
                              );
                            } else {
                              provider.addToCompare(widget.product);
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

                  // Google Map
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 250,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: productLocation,
                          zoom: 16.5,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.product.ref),
                            position: productLocation,
                            infoWindow: InfoWindow(
                              title: widget.product.name,
                              snippet: productAddress ?? "Chargement...",
                            ),
                          ),
                        },
                        zoomControlsEnabled: true,
                        myLocationButtonEnabled: false,
                        liteModeEnabled: false,
                      ),
                    ),
                  ),

                  // Bouton ouvrir dans Google Maps
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final query = Uri.encodeComponent(
                          "${widget.product.provider} Madagascar",
                        );
                        final url = Uri.parse(
                          "https://www.google.com/maps/search/?api=1&query=$query",
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text("Ouvrir dans Google Maps"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: Colors.green[700],
                        side: BorderSide(color: Colors.green[700]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  //Text(
                  //  "Provider: ${widget.product.provider}\n"
                  //  "Location: $_providerLocation\n"
                  //  "Adresse: $productAddress",
                  //  style: const TextStyle(fontSize: 10, color: Colors.red),
                  //),
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
                                p.categoryLevel2 ==
                                    widget.product.categoryLevel2 &&
                                p.ref != widget.product.ref,
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

      // Floating Action Button
      floatingActionButton: (provider.isZero)
          ? FloatingActionButton(
              mini: true,
              onPressed: () {},
              child: const Icon(Icons.compare_arrows),
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
