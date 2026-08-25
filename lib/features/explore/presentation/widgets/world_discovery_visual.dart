import 'package:flutter/material.dart';

import '../../../../widgets/visuals/radio_visuals.dart';

class WorldDiscoveryVisual extends StatelessWidget {
  const WorldDiscoveryVisual({super.key});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(child: SignalRings()),
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            border: Border.fromBorderSide(
              BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(
              Icons.public,
              size: 28,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              semanticLabel: 'Global radio discovery',
            ),
          ),
        ),
      ],
    ),
  );
}
