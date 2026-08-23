import 'package:flutter/foundation.dart';

import '../../stations/data/radio_browser_service.dart';
import '../../stations/domain/radio_station.dart';

enum StationLoadState { loading, success, empty, error }

class HomeRadioController extends ChangeNotifier {
  HomeRadioController(this._service);
  final RadioBrowserService _service;
  StationLoadState state = StationLoadState.loading;
  List<RadioStation> stations = const [];

  Future<void> load() async {
    state = StationLoadState.loading;
    notifyListeners();
    try {
      stations = _deduplicate(await _service.getPopularStations());
      state = stations.isEmpty
          ? StationLoadState.empty
          : StationLoadState.success;
    } on RadioBrowserException {
      state = StationLoadState.error;
    }
    notifyListeners();
  }

  List<RadioStation> _deduplicate(List<RadioStation> values) => [
    ...{for (final station in values) station.stationUuid: station}.values,
  ];
  @override
  void dispose() {
    _service.close();
    super.dispose();
  }
}
