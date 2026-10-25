import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mini_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:flutter_mini_ecommerce/features/products/domain/product.dart';

void main() {
  const product = Product(
    id: 'test',
    name: 'Test product',
    price: 100,
    category: 'Test',
    imageUrl: '',
  );

  test('adding same product increments quantity and total', () {
    final cubit = CartCubit();
    cubit.add(product);
    cubit.add(product);

    expect(cubit.state.length, 1);
    expect(cubit.state.first.quantity, 2);
    expect(cubit.total, 200);

    cubit.decrease(product.id);
    expect(cubit.state.first.quantity, 1);

    cubit.remove(product.id);
    expect(cubit.state, isEmpty);
    cubit.close();
  });
}
