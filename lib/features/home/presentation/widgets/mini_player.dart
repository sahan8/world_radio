import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../player/application/player_controller.dart';
import '../../../library/application/library_controller.dart';
import '../../../player/presentation/player_screen.dart';
import '../../../player/presentation/widgets/player_artwork.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = PlayerScope.of(context);
    final library = LibraryScope.of(context);
    final station = controller.currentStation;
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 240),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
      child: station == null
          ? const SizedBox.shrink(key: ValueKey('inactive'))
          : Container(
              key: const ValueKey('active'),
              constraints: const BoxConstraints(minHeight: 82),
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevated,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              child: InkWell(
                key: const Key('mini-player-open'),
                onTap: () => Navigator.of(context).push(PlayerScreen.route()),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 9, 10, 9),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: PlayerArtwork(station: station),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Column(
                            key: ValueKey(station.id),
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                station.stationName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '${station.displayCountry} · ${station.technicalSummary}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: library.isFavorite(station.id)
                            ? 'Remove favorite'
                            : 'Add favorite',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          library.toggleFavorite(station);
                        },
                        icon: Icon(
                          library.isFavorite(station.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      IconButton.filled(
                        tooltip: controller.isLoading
                            ? 'Buffering ${station.stationName}'
                            : controller.hasError
                            ? 'Retry ${station.stationName}'
                            : controller.isPlaying
                            ? 'Pause ${station.stationName}'
                            : 'Play ${station.stationName}',
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          controller.togglePlaying();
                        },
                        icon: controller.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                controller.hasError
                                    ? Icons.refresh
                                    : controller.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                        constraints: const BoxConstraints.tightFor(
                          width: 48,
                          height: 48,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
