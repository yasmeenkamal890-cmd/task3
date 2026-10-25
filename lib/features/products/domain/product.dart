class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.apiId,
  });

  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;

  /// Numeric ID used by the Fake Store API for product details.
  final int? apiId;
}
