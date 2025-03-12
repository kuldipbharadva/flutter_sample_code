# flutter_sample_code
This repo have sample code of flutter app. This code have some common stuff and codes which will very useful while creating new apps.

# Generate model and route class file
flutter packages pub run build_runner build --delete-conflicting-outputs
dart run build_runner build --delete-conflicting-outputs

# Generate release build
flutter build apk --split-per-abi
flutter build apk --release

# Generate app icon
flutter pub run flutter_launcher_icons:main
dart run flutter_launcher_icons:main

# Rename app package, app name
dart run package_rename