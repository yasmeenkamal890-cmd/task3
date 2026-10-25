# Task 3 — Product Details API + Cubit, Favorites UI, Offers UI

## Included
- Product details page with image, title, category, price, description, rating, and retryable error state.
- `ProductDetailsCubit` with loading, success, and error states.
- `ProductDetailsRepository` that requests `https://fakestoreapi.com/products/{id}`.
- Favorites screen UI only.
- Offers screen UI only.
- Added Favorites and Offers to the existing bottom navigation without removing the Shop/Cart flow.

## API note
The uploaded project did not include a product API endpoint or API documentation, so the product details integration uses the public Fake Store API as a working example. Replace the repository URL and mapping with your assigned API if your instructor provided one.

## Run
```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
