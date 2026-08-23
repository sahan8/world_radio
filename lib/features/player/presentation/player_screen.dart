import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/player_controller.dart';
import 'widgets/player_artwork.dart';
import 'widgets/radio_waveform.dart';
import 'widgets/sleep_timer_sheet.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});
  static Route<void> route() => PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 220),
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
    final station = controller.currentStation;
    if (station == null) return const SizedBox.shrink();
    final favorite = controller.isFavorite(station);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Column(
            children: [
              Text('NOW PLAYING', style: AppTextStyles.caption),
              Text('WORLD RADIO', style: AppTextStyles.title),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'More options',
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: SafeArea(
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
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth > 480
                            ? 400
                            : constraints.maxWidth,
                      ),
                      child: PlayerArtwork(
                        key: ValueKey(station.id),
                        station: station,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.textPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        const Text('LIVE', style: AppTextStyles.caption),
                      ],
                    ),
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
                    const SizedBox(height: 24),
                    RadioWaveform(playing: controller.isPlaying),
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
                            controller.toggleFavorite();
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
                          icon: Icons.ios_share,
                          label: 'Share',
                          onTap: () {},
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
          decoration: const BoxDecoration(
            color: AppColors.controlPrimary,
            shape: BoxShape.circle,
          ),
          child: widget.loading
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: AppColors.controlOnPrimary,
                    strokeWidth: 3,
                  ),
                )
              : Icon(
                  widget.error
                      ? Icons.refresh
                      : widget.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: AppColors.controlOnPrimary,
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
  Widget build(BuildContext context) => InkResponse(
    onTap: onTap,
    radius: 34,
    child: SizedBox(
      width: 88,
      child: Column(
        children: [
          Icon(icon, size: 27),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
