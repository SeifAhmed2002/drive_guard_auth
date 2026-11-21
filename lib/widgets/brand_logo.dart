import 'package:flutter/material.dart';

import '../core/theme.dart';

class EyeMark extends StatelessWidget {
  final double width;
  final double height;
  const EyeMark({super.key, this.width = 34, this.height = 22});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/eye_mark.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class _EyeMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final thick = w * 0.075;

    final eye = Path()
      ..moveTo(w * .02, h * .5)
      ..quadraticBezierTo(w * .5, -h * .32, w * .98, h * .5)
      ..quadraticBezierTo(w * .5, h * 1.32, w * .02, h * .5)
      ..close();

    canvas.save();
    canvas.clipPath(eye);

    final thin = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * .5, h * .46), width: w * .26, height: h * .74),
      thin,
    );
    final shoulders = Path()
      ..moveTo(w * .30, h * 1.05)
      ..quadraticBezierTo(w * .32, h * .78, w * .44, h * .76)
      ..moveTo(w * .70, h * 1.05)
      ..quadraticBezierTo(w * .68, h * .78, w * .56, h * .76);
    canvas.drawPath(shoulders, thin);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * .5, h * .40), width: w * .27, height: h * .15),
        Radius.circular(w * .02),
      ),
      Paint()..color = AppColors.cyan,
    );
    canvas.restore();

    canvas.drawPath(
      eye,
      Paint()
        ..color = AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = thick
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const EyeMark(),
        const SizedBox(width: 14),
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