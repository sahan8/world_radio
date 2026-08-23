import 'package:flutter/foundation.dart';

import '../../stations/data/radio_browser_service.dart';
import '../../stations/domain/radio_station.dart';

enum StationLoadState { loading, success, empty, error }

class HomeRadioController extends ChangeNotifier {
  HomeRadioController(this._service);
  final RadioBrowserService _service;
  StationLoadState state = StationLoadState.loading;
  List<RadioStation> stations = const [];
  int _requestId = 0;
  bool _disposed = false;

  Future<void> load() async {
    final request = ++_requestId;
    state = StationLoadState.loading;
    notifyListeners();
    try {
      final values = _deduplicate(await _service.getPopularStations());
      if (request != _requestId || _disposed) return;
      stations = values;
      state = stations.isEmpty
          ? StationLoadState.empty
          : StationLoadState.success;
    } on RadioBrowserException {
      if (request != _requestId || _disposed) return;
      state = StationLoadState.error;
    }
    if (!_disposed) notifyListeners();
  }

  List<RadioStation> _deduplicate(List<RadioStation> values) => [
    ...{for (final station in values) station.stationUuid: station}.values,
  ];
  @override
  void dispose() {
    _disposed = true;
    _requestId++;
    _service.close();
    super.dispose();
  }
}
