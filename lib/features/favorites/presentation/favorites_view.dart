import 'package:flutter/material.dart';

import '../../products/data/mock_products.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // UI-only screen for this task: sample cards are static and not connected to a favorites Cubit/API.
    final favorites = mockProducts.take(3).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Your favorites',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Keep the things you love in one place.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        ...favorites.map((product) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(product.imageUrl, width: 86, height: 86,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 86, height: 86,
                  color: const Color(0xFFECE8F5),
                  child: const Icon(Icons.image_not_supported_outlined)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                Text('${product.price.toStringAsFixed(0)} USD',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
              ],
            )),
            Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
          ]),
        )),
      ],
    );
  }
}
