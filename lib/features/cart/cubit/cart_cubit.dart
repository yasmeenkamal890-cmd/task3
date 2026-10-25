import 'package:flutter_bloc/flutter_bloc.dart';

import '../../products/domain/product.dart';
import '../domain/cart_item.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super(const []);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
  double get total => state.fold(0, (sum, item) => sum + item.lineTotal);

  void add(Product product) {
    final items = List<CartItem>.from(state);
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      items.add(CartItem(product: product));
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }
    emit(List.unmodifiable(items));
  }

  void increase(String productId) {
    final items = state
        .map((item) => item.product.id == productId
            ? item.copyWith(quantity: item.quantity + 1)
            : item)
        .toList();
    emit(List.unmodifiable(items));
  }

  void decrease(String productId) {
    final items = <CartItem>[];
    for (final item in state) {
      if (item.product.id != productId) {
        items.add(item);
      } else if (item.quantity > 1) {
        items.add(item.copyWith(quantity: item.quantity - 1));
      }
    }
    emit(List.unmodifiable(items));
  }

  void remove(String productId) {
    emit(List.unmodifiable(
      state.where((item) => item.product.id != productId).toList(),
    ));
  }

  void clear() => emit(const []);
}
