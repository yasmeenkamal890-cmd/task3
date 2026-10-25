import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_details_repository.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._repository) : super(const ProductDetailsState());

  final ProductDetailsRepository _repository;

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }

  Future<void> loadProduct(int productId) async {
    emit(const ProductDetailsState(status: ProductDetailsStatus.loading));
    try {
      final product = await _repository.fetchProductDetails(productId);
      emit(ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product,
      ));
    } catch (error) {
      emit(ProductDetailsState(
        status: ProductDetailsStatus.error,
        errorMessage: 'Could not load product details. Check your connection and try again.',
      ));
    }
  }
}
