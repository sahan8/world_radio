# World Radio

A cross-platform Flutter radio receiver for discovering and listening to live
stations around the world. It uses a responsive monochrome neumorphic interface
with accessible controls and motion-reduction support.

## Features

- Discovery by country, genre, and language
- Debounced search with filters and pagination
- Background audio, queue navigation, retry states, and notification controls
- Favorites, listening history, and last-station restoration
- Persistent light, dark, and system themes
- Volume control and a real playback sleep timer

## Development

Use Flutter stable with Dart 3.13 or newer.

```sh
flutter pub get
flutter analyze
flutter test
flutter run --dart-define-from-file=.env
```

Copy `.env.example` to `.env` before local development. The local file is
ignored by Git. Release builds should also pass
`--dart-define-from-file=.env`. Never place private credentials in Flutter
environment defines: compiled mobile and web clients cannot keep secrets.

World Radio uses the public Radio Browser API. Individual station availability
can vary, so the app includes empty, retry, and signal-loss states.

## Security

- Only public HTTPS station, artwork, and directory URLs are accepted.
- URLs containing credentials or direct local/private-network destinations are
  rejected before playback or image loading.
- `.env`, signing files, private keys, and certificates are ignored by Git.
- Client environment defines are configuration, not a place for secrets.
- `web/_headers` provides a secure baseline for hosts that support `_headers`.
- Android release builds fail unless `android/key.properties` is configured.

## Release checklist

- Configure a private Android upload key before Play Store submission. Create
  `android/key.properties` with `storeFile`, `storePassword`, `keyAlias`, and
  `keyPassword`; the file and keystore are already ignored by Git.
- Set the final iOS development team and bundle identifier in Xcode.
- Run `flutter build appbundle --release` and `flutter build web --release`.

Version: 1.0.0+1
