import 'package:flutter/material.dart';

import '../../../player/presentation/widgets/player_artwork.dart';
import '../../domain/radio_station.dart';

class StationThumbnail extends StatelessWidget {
  const StationThumbnail({required this.station, this.size, super.key});
  final RadioStation station;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final fallback = PlayerArtwork(station: station, hero: false, size: size);
    if (!station.hasArtwork) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          station.favicon,
          fit: BoxFit.cover,
          semanticLabel: '${station.name} artwork',
          cacheWidth: size?.round(),
          cacheHeight: size?.round(),
          filterQuality: FilterQuality.low,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : fallback,
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }
}
