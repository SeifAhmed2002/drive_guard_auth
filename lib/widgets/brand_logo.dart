import 'package:material_ui/material_ui.dart';

import '../core/theme.dart';

/// Eye-guard mark. This is a code-drawn approximation of the Figma logo -
/// for the exact artwork export "Logo/Mark Eye Guard" as SVG from Figma and
/// render it with flutter_svg instead.
class EyeMark extends StatelessWidget {
  final double width;
  final double height;
  final bool tile;
  const EyeMark({super.key, this.width = 40, this.height = 40, this.tile = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _EyeMarkPainter(tile: tile)),
    );
  }
}

class _EyeMarkPainter extends CustomPainter {
  final bool tile;
  _EyeMarkPainter({required this.tile});

  @override
  void paint(Canvas canvas, Size s) {
    if (tile) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & s, Radius.circular(s.width * 0.23)),
        Paint()..color = AppColors.canvas,
      );
    }
    final inset = tile ? s.width * 0.0625 : 0.0;
    final w = s.width - inset * 2, h = s.height - inset * 2;
    canvas.save();
    canvas.translate(inset, inset);

    final stroke = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeJoin = StrokeJoin.round;
    final eye = Path()
      ..moveTo(w * .04, h * .5)
      ..quadraticBezierTo(w * .5, -h * .1, w * .96, h * .5)
      ..quadraticBezierTo(w * .5, h * 1.1, w * .04, h * .5)
      ..close();
    canvas.drawPath(eye, stroke);

    final white = Paint()..color = AppColors.textPrimary;
    // head + shoulders
    canvas.drawOval(Rect.fromCenter(center: Offset(w * .5, h * .44), width: w * .26, height: h * .42), white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(w * .5, h * .8), width: w * .42, height: h * .22), Radius.circular(w * .05)),
      white,
    );
    // glasses / lens
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(w * .5, h * .38), width: w * .3, height: h * .09), const Radius.circular(2)),
      Paint()..color = AppColors.cyan,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EyeMarkPainter old) => old.tile != tile;
}

/// Mark + DRIVE / GUARD wordmark.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const EyeMark(),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DRIVE', style: AppText.wordmark.copyWith(letterSpacing: 2.75)),
            const SizedBox(height: 2),
            Text('GUARD', style: AppText.wordmark),
          ],
        ),
      ],
    );
  }
}
