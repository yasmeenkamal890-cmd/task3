import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductDetails {
  const ProductDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final ratingMap = ratingJson is Map<String, dynamic>
        ? ratingJson
        : <String, dynamic>{};
    return ProductDetails(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Product',
      description: json['description'] as String? ?? 'No description available.',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? 'General',
      image: json['image'] as String? ?? '',
      rating: (ratingMap['rate'] as num?)?.toDouble() ?? 0,
      ratingCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductDetailsRepository {
  ProductDetailsRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ProductDetails> fetchProductDetails(int productId) async {
    final uri = Uri.parse('https://fakestoreapi.com/products/$productId');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Unable to load product details (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected product response.');
    }
    return ProductDetails.fromJson(decoded);
  }

  void dispose() => _client.close();
}
