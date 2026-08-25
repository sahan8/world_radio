/// Validation for URLs supplied by the public station directory.
///
/// Client-side checks cannot prevent DNS rebinding, but they prevent insecure
/// schemes and direct requests to obvious loopback/private destinations.
abstract final class SafeUri {
  static Uri? publicHttps(Object? value) {
    final uri = Uri.tryParse(value?.toString().trim() ?? '');
    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        _isPrivateHost(uri.host)) {
      return null;
    }
    return uri;
  }

  static bool _isPrivateHost(String rawHost) {
    final host = rawHost.toLowerCase().replaceAll(RegExp(r'^\[|\]$'), '');
    final ipv6 = host.contains(':');
    if (host == 'localhost' ||
        host.endsWith('.localhost') ||
        host.endsWith('.local') ||
        host == '::1' ||
        host == '0:0:0:0:0:0:0:1' ||
        (ipv6 &&
            (host.startsWith('fc') ||
                host.startsWith('fd') ||
                host.startsWith('fe80:'))) ||
        (host.startsWith('::ffff:') &&
            _isPrivateHost(host.substring('::ffff:'.length)))) {
      return true;
    }

    final octets = host.split('.').map(int.tryParse).toList(growable: false);
    if (octets.length != 4 || octets.any((part) => part == null)) return false;
    final values = octets.cast<int>();
    if (values.any((part) => part < 0 || part > 255)) return true;
    return values[0] == 0 ||
        values[0] == 10 ||
        values[0] == 127 ||
        (values[0] == 169 && values[1] == 254) ||
        (values[0] == 172 && values[1] >= 16 && values[1] <= 31) ||
        (values[0] == 192 && values[1] == 168) ||
        values[0] >= 224;
  }
}
