import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import '../data/product_details_repository.dart';
import '../domain/product.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state.status == ProductDetailsStatus.loading ||
              state.status == ProductDetailsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProductDetailsStatus.error || state.product == null) {
            return _MessageState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load details',
              message: state.errorMessage ?? 'Please try again.',
              buttonLabel: 'Retry',
              onPressed: () => context
                  .read<ProductDetailsCubit>()
                  .loadProduct(product.apiId ?? 1),
            );
          }

          final details = state.product!;
          return _ProductDetailsContent(details: details, fallback: product);
        },
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({required this.details, required this.fallback});

  final ProductDetails details;
  final Product fallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 290,
            color: Colors.white,
            padding: const EdgeInsets.all(22),
            child: Image.network(
              details.image.isEmpty ? fallback.imageUrl : details.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported_outlined, size: 64, color: Colors.black38,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(details.category.toUpperCase(),
            style: TextStyle(color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text(details.title, style: theme.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 22),
            const SizedBox(width: 5),
            Text(details.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            Text('(${details.ratingCount} reviews)',
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 18),
        Text('\$${details.price.toStringAsFixed(2)}',
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 22),
        Text('About this product',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(details.description,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5, color: Colors.black54)),
        const SizedBox(height: 26),
        FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product details loaded from API.')),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Product details loaded'),
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
      ]),
    ),
  );
}
