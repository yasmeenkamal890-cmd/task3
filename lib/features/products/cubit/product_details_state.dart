import '../data/product_details_repository.dart';

enum ProductDetailsStatus { initial, loading, success, error }

class ProductDetailsState {
  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.errorMessage,
  });

  final ProductDetailsStatus status;
  final ProductDetails? product;
  final String? errorMessage;
}
