# Technical Documentation — Flutter Mini E-Commerce

## 1. Overview

This is a deliberately small e-commerce demo with two top-level flows:

1. **Login page** — validates email/password input and simulates authentication.
2. **Shop shell** — one persistent page shell with two tabs: Shop and Cart. This keeps the requested experience small while still providing a separate Cart view.

Products are supplied by local mock data. Product photos use remote image URLs and fall back to a placeholder if loading fails.

## 2. Architecture and project structure

I used a **feature-first, lightweight layered architecture**. It keeps code grouped by business feature without introducing unnecessary Clean Architecture ceremony for a mini task.

```text
lib/
├── main.dart
└── features/
    ├── auth/
    │   ├── cubit/auth_cubit.dart
    │   └── presentation/login_page.dart
    ├── products/
    │   ├── data/mock_products.dart
    │   └── domain/product.dart
    ├── cart/
    │   ├── cubit/cart_cubit.dart
    │   ├── domain/cart_item.dart
    │   └── presentation/cart_view.dart
    └── shop/
        └── presentation/shop_shell.dart
```

- **Domain/model:** `Product` and `CartItem` represent the data used by the UI.
- **Data:** `mock_products.dart` is the local product source.
- **Cubit:** contains state transitions and business rules, such as quantity changes and total calculation.
- **Presentation:** Flutter widgets render state and forward user actions to Cubits.
- **Composition root:** `main.dart` registers `AuthCubit` and `CartCubit` above the app's navigation flow.

The feature-first structure makes each feature easy to find and allows a real repository/API to be introduced later without rewriting the widgets.

## 3. Why Cubit?

I chose **Cubit from `flutter_bloc`** because this app has a small, clear set of user actions and does not need the extra event classes required by Bloc. Methods such as `add`, `increase`, `decrease`, and `remove` make the state transitions direct and easy to read.

## 4. State management

### Authentication

`AuthCubit` exposes `AuthStatus` values:

- `initial`: no login attempt yet.
- `loading`: the mock login is being processed.
- `success`: credentials pass basic validation; the UI navigates to the shop.
- `failure`: validation fails and the UI displays an error.

This is **mock authentication only**. Any email containing `@` and any non-empty password are accepted. It is not secure and must not be used as real authentication.

### Cart

`CartCubit` owns the cart state as a list of `CartItem` objects. Each item contains a product and quantity.

- Adding an existing product increments its quantity rather than duplicating the line.
- Decreasing quantity stops at one; pressing minus at quantity one removes that line.
- Remove deletes a line immediately.
- `itemCount` sums quantities for the cart badge.
- `total` sums each item's `price × quantity`.

A new list is emitted after every mutation so `BlocBuilder` receives a new state and redraws the relevant UI.

### Keeping the cart while navigating

Both Cubits are provided above `MaterialApp` using `MultiBlocProvider`. The Shop and Cart are tabs inside the same `ShopShell`; `IndexedStack` keeps both tab subtrees mounted. As a result, switching between Shop and Cart does not recreate the Cubit or discard cart contents.

## 5. Important technical decisions

- **No backend:** mock login and local product data keep the sample easy to run and review.
- **Two top-level pages:** login and shop shell; Shop and Cart are separate tabs inside the shell to meet the small-project scope and cart requirement.
- **Immutable-style updates:** cart operations create and emit a new list rather than mutating the existing state list.
- **Input validation:** email must contain `@`, and password must not be empty.
- **Image fallback:** network image failures show a placeholder instead of breaking the product card.
- **Checkout is intentionally a demo placeholder:** payment and order submission are outside the requirements.

## 6. Challenges

The main design challenge is keeping the cart state alive while moving between the product list and cart. Providing `CartCubit` at the app level and using a shared tab shell solves that without storage or a backend. Another consideration is handling repeated product additions consistently; the Cubit merges the same product into one line and increments its quantity.

## 7. What I would improve for production

1. Add a repository layer and a real API for authentication, products, inventory, and orders.
2. Use secure token storage and proper session expiry; never trust client-side mock authentication.
3. Persist the cart locally (for example with a database or key-value storage) and sync it to the user's account.
4. Add unit tests for `CartCubit` and `AuthCubit`, plus widget tests for login and cart interactions.
5. Add loading/error/empty states for network requests, retry image loading, and use cached images.
6. Add currency/price formatting, accessibility checks, localization, and responsive UI testing.
7. Add checkout validation, payment integration, order confirmation, analytics, and CI checks.

## 8. Verification checklist

- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Manual flow: login → add products → cart → quantity changes → remove item → total updates
- [ ] Record the flow using `DEMO_SCRIPT.md`


## 9. Task 3 — Product details, Favorites, and Offers

- **Product details:** the product card opens a dedicated details page. `ProductDetailsCubit` emits loading/success/error states and calls `ProductDetailsRepository`, which requests a single product from the public Fake Store API (`https://fakestoreapi.com/products/{id}`). The API is used because no project-specific API endpoint or API documentation was included in the supplied archive.
- **Favorites:** `FavoritesView` is a UI-only screen using sample product cards. It is intentionally not connected to a favorites state or API.
- **Offers:** `OffersView` is a UI-only screen showing a promotional banner and sample offer cards. The displayed 20% discount is illustrative UI content, not a live offer from a backend.
- **Navigation:** Shop, Cart, Favorites, and Offers are tabs in the existing `ShopShell`. Product details opens as a separate route.
- **Dependency:** `http` is used for the product details request. Run `flutter pub get` after pulling these changes.
