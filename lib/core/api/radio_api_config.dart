abstract final class RadioApiConfig {
  static const baseUrl = 'https://de1.api.radio-browser.info';
  static const pageSize = 20;
  static const userAgent = 'WorldRadio/1.0 Flutter';
  static const timeout = Duration(seconds: 12);
  static const headers = <String, String>{
    'User-Agent': userAgent,
    'Accept': 'application/json',
  };
}
