import 'package:flutter/material.dart';

class DotMatrixText extends StatelessWidget {
  const DotMatrixText(
    this.text, {
    this.fontSize = 20,
    this.color,
    this.spacing = 1,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    super.key,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final double spacing;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Semantics(
    label: text,
    child: ExcludeSemantics(
      child: CustomPaint(
        painter: _DotTextPainter(
          text.toUpperCase(),
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontSize: fontSize,
          spacing: spacing,
          maxLines: maxLines,
          textAlign: textAlign,
        ),
        size: Size(double.infinity, fontSize * 1.12 * maxLines),
      ),
    ),
  );
}

class _DotTextPainter extends CustomPainter {
  const _DotTextPainter(
    this.text, {
    required this.color,
    required this.fontSize,
    required this.spacing,
    required this.maxLines,
    required this.textAlign,
  });

  final String text;
  final Color color;
  final double fontSize;
  final double spacing;
  final int maxLines;
  final TextAlign textAlign;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = fontSize / 8;
    final advance = dot * (6 + spacing);
    final maxChars = (size.width / advance).floor().clamp(1, text.length);
    final lines = <String>[];
    for (var offset = 0; offset < text.length && lines.length < maxLines;) {
      final end = (offset + maxChars).clamp(0, text.length);
      lines.add(text.substring(offset, end));
      offset = end;
    }
    final paint = Paint()..color = color;
    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      final lineWidth = line.length * advance - dot * spacing;
      final originX = switch (textAlign) {
        TextAlign.center => (size.width - lineWidth) / 2,
        TextAlign.right || TextAlign.end => size.width - lineWidth,
        _ => 0.0,
      };
      for (var charIndex = 0; charIndex < line.length; charIndex++) {
        final glyph = _glyphs[line[charIndex]] ?? _glyphs['?']!;
        for (var row = 0; row < 7; row++) {
          for (var column = 0; column < 5; column++) {
            if (glyph[row][column] == '1') {
              canvas.drawCircle(
                Offset(
                  originX + charIndex * advance + column * dot + dot / 2,
                  lineIndex * fontSize * 1.12 + row * dot + dot / 2,
                ),
                dot * .32,
                paint,
              );
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DotTextPainter old) =>
      old.text != text ||
      old.color != color ||
      old.fontSize != fontSize ||
      old.spacing != spacing ||
      old.maxLines != maxLines ||
      old.textAlign != textAlign;
}

const _glyphs = <String, List<String>>{
  ' ': ['00000', '00000', '00000', '00000', '00000', '00000', '00000'],
  '?': ['01110', '10001', '00001', '00110', '00100', '00000', '00100'],
  '/': ['00001', '00010', '00100', '01000', '10000', '00000', '00000'],
  '-': ['00000', '00000', '00000', '11111', '00000', '00000', '00000'],
  '0': ['01110', '10001', '10011', '10101', '11001', '10001', '01110'],
  '1': ['00100', '01100', '00100', '00100', '00100', '00100', '01110'],
  '2': ['01110', '10001', '00001', '00010', '00100', '01000', '11111'],
  '3': ['11110', '00001', '00001', '01110', '00001', '00001', '11110'],
  '4': ['00010', '00110', '01010', '10010', '11111', '00010', '00010'],
  '5': ['11111', '10000', '10000', '11110', '00001', '00001', '11110'],
  '6': ['01110', '10000', '10000', '11110', '10001', '10001', '01110'],
  '7': ['11111', '00001', '00010', '00100', '01000', '01000', '01000'],
  '8': ['01110', '10001', '10001', '01110', '10001', '10001', '01110'],
  '9': ['01110', '10001', '10001', '01111', '00001', '00001', '01110'],
  'A': ['01110', '10001', '10001', '11111', '10001', '10001', '10001'],
  'B': ['11110', '10001', '10001', '11110', '10001', '10001', '11110'],
  'C': ['01111', '10000', '10000', '10000', '10000', '10000', '01111'],
  'D': ['11110', '10001', '10001', '10001', '10001', '10001', '11110'],
  'E': ['11111', '10000', '10000', '11110', '10000', '10000', '11111'],
  'F': ['11111', '10000', '10000', '11110', '10000', '10000', '10000'],
  'G': ['01111', '10000', '10000', '10111', '10001', '10001', '01111'],
  'H': ['10001', '10001', '10001', '11111', '10001', '10001', '10001'],
  'I': ['11111', '00100', '00100', '00100', '00100', '00100', '11111'],
  'J': ['00111', '00010', '00010', '00010', '10010', '10010', '01100'],
  'K': ['10001', '10010', '10100', '11000', '10100', '10010', '10001'],
  'L': ['10000', '10000', '10000', '10000', '10000', '10000', '11111'],
  'M': ['10001', '11011', '10101', '10101', '10001', '10001', '10001'],
  'N': ['10001', '11001', '10101', '10011', '10001', '10001', '10001'],
  'O': ['01110', '10001', '10001', '10001', '10001', '10001', '01110'],
  'P': ['11110', '10001', '10001', '11110', '10000', '10000', '10000'],
  'Q': ['01110', '10001', '10001', '10001', '10101', '10010', '01101'],
  'R': ['11110', '10001', '10001', '11110', '10100', '10010', '10001'],
  'S': ['01111', '10000', '10000', '01110', '00001', '00001', '11110'],
  'T': ['11111', '00100', '00100', '00100', '00100', '00100', '00100'],
  'U': ['10001', '10001', '10001', '10001', '10001', '10001', '01110'],
  'V': ['10001', '10001', '10001', '10001', '10001', '01010', '00100'],
  'W': ['10001', '10001', '10001', '10101', '10101', '10101', '01010'],
  'X': ['10001', '10001', '01010', '00100', '01010', '10001', '10001'],
  'Y': ['10001', '10001', '01010', '00100', '00100', '00100', '00100'],
  'Z': ['11111', '00001', '00010', '00100', '01000', '10000', '11111'],
};
