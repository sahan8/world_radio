import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/neumorphic.dart';
import '../application/player_controller.dart';
import '../../library/application/library_controller.dart';
import 'widgets/radio_waveform.dart';
import 'widgets/sleep_timer_sheet.dart';
import '../../../core/motion/app_motion.dart';
import '../../../widgets/visuals/radio_visuals.dart';
import '../../../widgets/visuals/dot_matrix_text.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});
  static Route<void> route() => PageRouteBuilder(
    transitionDuration: AppMotion.emphasis,
    reverseTransitionDuration: AppMotion.standard,
    pageBuilder: (_, animation, _) => const PlayerScreen(),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, .025),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = PlayerScope.of(context);
    final library = LibraryScope.of(context);
    final station = controller.currentStation;
    if (station == null) return const SizedBox.shrink();
    final favorite = library.isFavorite(station.id);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Column(
            children: [
              SizedBox(
                width: 160,
                height: 16,
                child: DotMatrixText(
                  'WORLD RADIO',
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              Text('ON AIR', style: AppTextStyles.caption),
            ],
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 44,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: Neumorphic.raised(context, depth: .8),
                          ),
                          child: Hero(
                            tag: 'station-signal-${station.id}',
                            child: DotMatrixSignal(
                              key: ValueKey('signal-${station.id}'),
                              size: 250,
                              active: controller.isPlaying,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        BroadcastIndicator(active: controller.isPlaying),
                        const SizedBox(height: 12),
                        Text(
                          station.stationName.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          [
                            if (station.city.isNotEmpty) station.city,
                            station.displayCountry,
                          ].join(', '),
                          style: AppTextStyles.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${station.technicalSummary} · ${station.primaryGenre} · ${station.primaryLanguage}',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 240,
                          height: 60,
                          child: DotMatrixText(
                            station.bitrate > 0 ? '${station.bitrate}' : 'LIVE',
                            fontSize: 58,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          station.bitrate > 0 ? 'KBPS' : 'ON AIR',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 22),
                        RadioWaveform(
                          playing: controller.isPlaying,
                          buffering: controller.isLoading,
                          error: controller.hasError,
                        ),
                        if (controller.hasError) ...[
                          const SizedBox(height: 12),
                          Text(
                            'SIGNAL LOST',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "This station isn't responding right now.",
                            style: AppTextStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: controller.retry,
                                child: const Text('TRY AGAIN'),
                              ),
                              if (controller.canNext) ...[
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: controller.next,
                                  child: const Text('NEXT STATION'),
                                ),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              tooltip: 'Previous station',
                              onPressed: controller.canPrevious
                                  ? () {
                                      HapticFeedback.selectionClick();
                                      controller.previous();
                                    }
                                  : null,
                              icon: const Icon(Icons.skip_previous),
                              iconSize: 34,
                            ),
                            _PlayButton(
                              playing: controller.isPlaying,
                              loading: controller.isLoading,
                              error: controller.hasError,
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                controller.togglePlaying();
                              },
                            ),
                            IconButton(
                              tooltip: 'Next station',
                              onPressed: controller.canNext
                                  ? () {
                                      HapticFeedback.selectionClick();
                                      controller.next();
                                    }
                                  : null,
                              icon: const Icon(Icons.skip_next),
                              iconSize: 34,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          controller.isLoading
                              ? 'BUFFERING'
                              : controller.hasError
                              ? 'RETRY'
                              : controller.isPlaying
                              ? 'PAUSE'
                              : 'PLAY',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Action(
                              icon: favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              label: 'Favorite',
                              onTap: () {
                                HapticFeedback.lightImpact();
                                library.toggleFavorite(station);
                              },
                            ),
                            _Action(
                              icon: Icons.bedtime_outlined,
                              label: controller.sleepTimer == 'Off'
                                  ? 'Sleep'
                                  : controller.sleepTimer,
                              onTap: () => showSleepTimerSheet(context),
                            ),
                            _Action(
                              icon: Icons.link_rounded,
                              label: 'Copy link',
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: station.streamUrl),
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Station link copied.'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.volume_down),
                            Expanded(
                              child: Slider(
                                value: controller.volume,
                                semanticFormatterCallback: (v) =>
                                    '${(v * 100).round()} percent',
                                onChanged: controller.setVolume,
                              ),
                            ),
                            const Icon(Icons.volume_up),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({
    required this.playing,
    required this.loading,
    required this.error,
    required this.onPressed,
  });
  final bool playing;
  final bool loading;
  final bool error;
  final VoidCallback onPressed;
  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => down = true),
    onTapCancel: () => setState(() => down = false),
    onTapUp: (_) {
      setState(() => down = false);
      widget.onPressed();
    },
    child: AnimatedScale(
      scale: down ? .94 : 1,
      duration: const Duration(milliseconds: 90),
      child: Semantics(
        button: true,
        excludeSemantics: true,
        label: widget.loading
            ? 'Station buffering'
            : widget.error
            ? 'Retry station'
            : widget.playing
            ? 'Pause station'
            : 'Play station',
        child: Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow
                    .withValues(alpha: .28),
                blurRadius: down ? 4 : 14,
                offset: Offset(0, down ? 2 : 7),
              ),
            ],
          ),
          child: widget.loading
              ? Center(
                  child: SignalLoader(
                    compact: true,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Icon(
                  widget.error
                      ? Icons.refresh
                      : widget.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 42,
                ),
        ),
      ),
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 34,
        child: SizedBox(
          width: 88,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: Neumorphic.raised(context, depth: .45),
                ),
                child: Icon(icon, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
