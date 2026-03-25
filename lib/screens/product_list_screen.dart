import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'comparison_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
    );

    // Écoute les changements dans la barre de recherche
    searchController.addListener(() {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).searchProduct(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tsena Mora"),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.compare_arrows),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComparisonScreen(),
                        ),
                      );
                    },
                  ),
                  if (provider.comparisonList.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${provider.comparisonList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // ── Search Bar ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un produit...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              Provider.of<ProductProvider>(
                                context,
                                listen: false,
                              ).searchProduct('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // ── Filters ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text(
                            "Category: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: const Text("All"),
                            selected: provider.selectedCategoryLevel1 == null,
                            onSelected: (selected) {
                              if (selected) provider.setCategoryLevel1(null);
                            },
                          ),
                          const SizedBox(width: 8),
                          ...provider.categoryLevel1Options.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(category),
                                selected:
                                    provider.selectedCategoryLevel1 == category,
                                onSelected: (selected) {
                                  provider.setCategoryLevel1(
                                    selected ? category : null,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    if (provider.selectedCategoryLevel1 != null)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              "Sub-Category: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: const Text("All"),
                              selected: provider.selectedCategoryLevel2 == null,
                              onSelected: (selected) {
                                if (selected) provider.setCategoryLevel2(null);
                              },
                            ),
                            const SizedBox(width: 8),
                            ...provider.categoryLevel2Options.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(category),
                                  selected:
                                      provider.selectedCategoryLevel2 ==
                                      category,
                                  onSelected: (selected) {
                                    provider.setCategoryLevel2(
                                      selected ? category : null,
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ── Résultat de recherche ────────────────────────────────
              if (searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${provider.products.length} résultat(s) pour "${searchController.text}"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),

              // ── Grid ────────────────────────────────────────────────
              Expanded(
                child: provider.products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aucun produit trouvé',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: provider.products[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: (provider.isZero)
          ? null
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
