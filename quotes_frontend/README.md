# quotes_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### On Arch/Manjaro:
1. Install flutter 
2. `sudo chown -R [user]:root /opt/flutter`


### Update:
1. `flutter channel stable`
2. `flutter upgrade`

### Run app:
1. `cd quotes_frontend`
2. `export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable`
3. `flutter config --enable-web`
4. `flutter build web`
5. `flutter run -d chrome` or `cd ./build/web/ && python3 -m http.server`



