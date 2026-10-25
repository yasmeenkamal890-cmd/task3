# Flutter Mini E-Commerce App

A small Flutter demo built with **Cubit (`flutter_bloc`)**. It contains a mock login and a mini shop with a cart, quantity controls, item removal, and a live total.

## Run locally

1. Install Flutter and verify it with `flutter doctor`.
2. Extract this project and open the project folder in VS Code or Android Studio.
3. Run:

   ```bash
   flutter pub get
   flutter run
   ```

## Demo login

Use any valid-looking email (for example `demo@example.com`) and any non-empty password. Authentication is mocked; there is no backend.

## Main flow

1. Enter email and password, then tap **Sign in**.
2. Add products from the Shop tab.
3. Open the Cart tab; the cart remains populated when switching tabs.
4. Increase/decrease quantity or remove products. The total updates automatically.
5. Sign out using the top-right icon.

## Project notes

- `ARCHITECTURE.md` explains the architecture, Cubit state management, decisions, limitations, and production improvements.
- `DEMO_SCRIPT.md` is a short script for recording the required demo video.

## Push to GitHub

Create an empty repository on GitHub, then run these commands from this folder:

```bash
git init
git add .
git commit -m "Build Flutter mini e-commerce app with Cubit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Replace the remote URL with your own repository URL. Do not commit generated build files or secrets.
