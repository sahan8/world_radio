abstract final class RadioApiConfig {
  static const baseUrl = String.fromEnvironment(
    'RADIO_API_BASE_URL',
    defaultValue: 'https://de1.api.radio-browser.info',
  );
  static const pageSize = 20;
  static const userAgent = String.fromEnvironment(
    'RADIO_API_USER_AGENT',
    defaultValue: 'WorldRadio/1.0 Flutter',
  );
  static const timeout = Duration(seconds: 12);
  static const headers = <String, String>{
    'User-Agent': userAgent,
    'Accept': 'application/json',
  };
}
