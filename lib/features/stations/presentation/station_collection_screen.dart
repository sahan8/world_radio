import 'package:flutter/material.dart';

import '../data/radio_browser_service.dart';
import '../domain/radio_station.dart';
import '../../search/presentation/widgets/search_result_tile.dart';

enum StationCollectionType { country, genre, language }

class StationCollectionScreen extends StatefulWidget {
  const StationCollectionScreen({
    required this.title,
    required this.value,
    required this.type,
    super.key,
  });
  final String title;
  final String value;
  final StationCollectionType type;
  @override
  State<StationCollectionScreen> createState() =>
      _StationCollectionScreenState();
}

class _StationCollectionScreenState extends State<StationCollectionScreen> {
  final _service = RadioBrowserService();
  final _scroll = ScrollController();
  final _stations = <RadioStation>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _error = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _service.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 400) _load(more: true);
  }

  Future<void> _load({bool more = false}) async {
    if (more && (!_hasMore || _loadingMore || _loading)) return;
    final request = more ? _requestId : ++_requestId;
    setState(() {
      if (more) {
        _loadingMore = true;
      } else {
        _loading = true;
        _error = false;
      }
    });
    try {
      final values = switch (widget.type) {
        StationCollectionType.country =>
          await _service.getStationsByCountryCode(
            widget.value,
            offset: more ? _stations.length : 0,
          ),
        StationCollectionType.genre => await _service.getStationsByTag(
          widget.value,
          offset: more ? _stations.length : 0,
        ),
        StationCollectionType.language => await _service.getStationsByLanguage(
          widget.value,
          offset: more ? _stations.length : 0,
        ),
      };
      if (!mounted || request != _requestId) return;
      final byId = {
        for (final station in [
          ...(more ? _stations : <RadioStation>[]),
          ...values,
        ])
          station.stationUuid: station,
      };
      setState(() {
        _stations
          ..clear()
          ..addAll(byId.values);
        _hasMore = values.length >= 20;
        _loading = false;
        _loadingMore = false;
      });
    } on RadioBrowserException {
      if (mounted && request == _requestId) {
        setState(() {
          _error = !more;
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title.toUpperCase())),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error && _stations.isEmpty
        ? _CollectionMessage(
            icon: Icons.signal_wifi_connected_no_internet_4,
            title: 'NO SIGNAL',
            message: "We couldn't reach the radio network.",
            action: _load,
          )
        : _stations.isEmpty
        ? const _CollectionMessage(
            icon: Icons.radio_outlined,
            title: 'NO STATIONS FOUND',
            message: 'Try another country, genre or search.',
          )
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView.separated(
              controller: _scroll,
              padding: const EdgeInsets.all(24),
              itemCount: _stations.length + (_loadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) => index == _stations.length
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SearchResultTile(
                      station: _stations[index],
                      queue: _stations,
                    ),
            ),
          ),
  );
}

class _CollectionMessage extends StatelessWidget {
  const _CollectionMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
          if (action != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: OutlinedButton(
                onPressed: action,
                child: const Text('TRY AGAIN'),
              ),
            ),
        ],
      ),
    ),
  );
}
