import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/cubit/login_cubit.dart';
import '../../auth/presentation/login_page.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/presentation/cart_view.dart';
import '../../favorites/presentation/favorites_view.dart';
import '../../offers/presentation/offers_view.dart';
import '../../products/cubit/product_details_cubit.dart';
import '../../products/data/mock_products.dart';
import '../../products/data/product_details_repository.dart';
import '../../products/domain/product.dart';
import '../../products/presentation/product_details_page.dart';

class ShopShell extends StatefulWidget {
  const ShopShell({super.key});

  @override
  State<ShopShell> createState() => _ShopShellState();
}

class _ShopShellState extends State<ShopShell> {
  int _selectedIndex = 0;

  String get _title => const ['Mini Shop', 'Your Cart', 'Favorites', 'Offers'][_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeView(onOpenCart: () => setState(() => _selectedIndex = 1),
        onOpenProduct: _openProduct),
      const CartView(),
      const FavoritesView(),
      const OffersView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              context.read<LoginCubit>().reset();
              context.read<CartCubit>().clear();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: BlocBuilder<CartCubit, dynamic>(
              builder: (context, state) => _CartIcon(
                count: context.read<CartCubit>().itemCount,
              ),
            ),
            selectedIcon: BlocBuilder<CartCubit, dynamic>(
              builder: (context, state) => _CartIcon(
                count: context.read<CartCubit>().itemCount,
                filled: true,
              ),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          const NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
        ],
      ),
    );
  }

  void _openProduct(Product product) {
    final apiId = product.apiId ?? 1;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ProductDetailsCubit(ProductDetailsRepository())
            ..loadProduct(apiId),
          child: ProductDetailsPage(product: product),
        ),
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count, this.filled = false});
  final int count;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(filled ? Icons.shopping_cart : Icons.shopping_cart_outlined),
        if (count > 0)
          Positioned(
            right: -10,
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text('$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ),
      ],
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.onOpenCart, required this.onOpenProduct});
  final VoidCallback onOpenCart;
  final ValueChanged<Product> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find your favorites',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('A few good things, picked just for you.',
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Small finds. Big smiles.',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Explore the mini collection'),
                          ],
                        ),
                      ),
                      Icon(Icons.local_mall_outlined, size: 38,
                          color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onOpenCart,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('View cart'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(
                product: mockProducts[index],
                onOpenDetails: () => onOpenProduct(mockProducts[index]),
              ),
              childCount: mockProducts.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onOpenDetails});
  final Product product;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: onOpenDetails,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFECE8F5),
                      child: const Icon(Icons.image_not_supported_outlined,
                          size: 42, color: Colors.black38),
                    ),
                  ),
                ),
                Positioned(
                  top: 9,
                  left: 9,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(product.category, style: const TextStyle(fontSize: 10)),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 4,
                  child: IconButton(
                    tooltip: 'View product details',
                    onPressed: onOpenDetails,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.9)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
            child: InkWell(
              onTap: onOpenDetails,
              child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text('${product.price.toStringAsFixed(0)} USD',
                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  context.read<CartCubit>().add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart'),
                        duration: const Duration(milliseconds: 900)),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 17),
                label: const Text('Add to cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
