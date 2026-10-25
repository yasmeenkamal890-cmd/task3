import 'package:flutter/material.dart';

import '../../products/data/mock_products.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final products = mockProducts.take(4).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Special offers',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Good finds, at even better prices.',
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WEEKLY DEALS', style: TextStyle(color: Colors.white70,
                  fontWeight: FontWeight.bold, letterSpacing: 1.3)),
                SizedBox(height: 8),
                Text('Up to 30% off',
                  style: TextStyle(color: Colors.white, fontSize: 26,
                    fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Find something you will love.',
                  style: TextStyle(color: Colors.white)),
              ],
            )),
            Icon(Icons.local_offer_rounded, color: Colors.white, size: 54),
          ]),
        ),
        const SizedBox(height: 22),
        Text('Deals for you', style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...products.map((product) {
          final oldPrice = product.price * 1.2;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(product.imageUrl, width: 82, height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 82, height: 82,
                    color: const Color(0xFFECE8F5),
                    child: const Icon(Icons.image_not_supported_outlined)),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 7),
                  Row(children: [
                    Text('${product.price.toStringAsFixed(0)} USD',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('${oldPrice.toStringAsFixed(0)} USD',
                      style: const TextStyle(color: Colors.black45,
                        decoration: TextDecoration.lineThrough, fontSize: 12)),
                  ]),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFE7D6),
                  borderRadius: BorderRadius.circular(10)),
                child: const Text('SAVE 20%', style: TextStyle(
                  color: Color(0xFFAD4B00), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]),
          );
        }),
      ],
    );
  }
}
