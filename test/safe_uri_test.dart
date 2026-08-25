import 'package:flutter_test/flutter_test.dart';
import 'package:world_radio/core/security/safe_uri.dart';

void main() {
  group('SafeUri.publicHttps', () {
    test('accepts public HTTPS URLs and non-default ports', () {
      expect(
        SafeUri.publicHttps('https://radio.example.com:8443/live')?.host,
        'radio.example.com',
      );
      expect(
        SafeUri.publicHttps('https://[2001:4860:4860::8888]/stream'),
        isNotNull,
      );
    });

    test('rejects cleartext and credential-bearing URLs', () {
      expect(SafeUri.publicHttps('http://radio.example.com/live'), isNull);
      expect(
        SafeUri.publicHttps('https://user:password@radio.example.com/live'),
        isNull,
      );
    });

    test('rejects local, private, link-local, and multicast hosts', () {
      for (final url in const [
        'https://localhost/live',
        'https://radio.local/live',
        'https://127.0.0.1/live',
        'https://10.0.0.1/live',
        'https://172.16.0.1/live',
        'https://192.168.1.1/live',
        'https://169.254.1.1/live',
        'https://224.0.0.1/live',
        'https://[::1]/live',
        'https://[fd00::1]/live',
        'https://[fe80::1]/live',
        'https://[::ffff:127.0.0.1]/live',
      ]) {
        expect(SafeUri.publicHttps(url), isNull, reason: url);
      }
    });

    test('rejects malformed and unsupported URLs', () {
      expect(SafeUri.publicHttps(''), isNull);
      expect(SafeUri.publicHttps('not a url'), isNull);
      expect(SafeUri.publicHttps('file:///tmp/radio.mp3'), isNull);
    });
  });
}
