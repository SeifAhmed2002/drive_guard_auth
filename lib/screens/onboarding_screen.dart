import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class _Slide {
  final String title;
  final String body;
  final Widget hero;
  const _Slide(this.title, this.body, this.hero);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _slides = <_Slide>[
    _Slide(
      'Stay alert on every drive',
      "Your phone's front camera watches your eyes, head and hands while you drive.",
      const _WatchHero(),
    ),
    _Slide(
      'An alarm within 2 seconds',
      'Eyes closing, head nodding or a phone in your hand triggers a loud alarm right away.',
      const _AlertHero(),
    ),
    _Slide(
      'No video leaves your phone',
      'Video is checked on your phone and never saved. Only the trip summary is uploaded.',
      const _PrivacyHero(),
    ),
  ];

  bool get _isLast => _index == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

  void _next() {
    if (_isLast) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.lg, 12, AppSpace.lg, 0),
                child: Row(
                  children: [
                    const BrandLogo(),
                    const Spacer(),
                    if (!_isLast)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _goLogin,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Text(
                            'Skip',
                            style: AppText.label.copyWith(fontSize: 16, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(width: 360, height: 360, child: s.hero),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.xs, AppSpace.lg, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: AppText.h1),
                            const SizedBox(height: AppSpace.sm),
                            Text(s.body, style: AppText.bodyLarge),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepBar(index: _index, count: _slides.length),
                  const SizedBox(height: AppSpace.lg),
                  PrimaryButton(label: _isLast ? 'Get started' : 'Next', onPressed: _next),
                  if (_isLast) ...[
                    const SizedBox(height: AppSpace.xs),
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _goLogin,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Wrap(
                            spacing: 4,
                            children: [
                              Text('Already have an account?', style: AppText.bodySmall),
                              Text('Sign in',
                                  style: AppText.label.copyWith(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Active = 32 wide white. Past = lighter grey. Upcoming = dark grey.
class _StepBar extends StatelessWidget {
  final int index;
  final int count;
  const _StepBar({required this.index, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        final color = active
            ? AppColors.textPrimary
            : (i < index ? const Color(0xFF737373) : const Color(0xFF404040));
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: i == count - 1 ? 0 : 6),
          width: active ? 32 : 16,
          height: 4,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
        );
      }),
    );
  }
}

// ------------------------------------------------------------ heroes

class _RingsPainter extends CustomPainter {
  final Offset center;
  const _RingsPainter(this.center);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.borderStrong.withOpacity(0.7);
    canvas.drawCircle(center, 120, p);
    canvas.drawCircle(center, 165, p);

    // outer dashed ring
    final path = Path()..addOval(Rect.fromCircle(center: center, radius: 205));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 4), p);
        d += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: AppColors.safe, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(label, style: AppText.caption.copyWith(fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _WatchHero extends StatelessWidget {
  const _WatchHero();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: CustomPaint(painter: _RingsPainter(Offset(164, 180))),
        ),
         Positioned(
                left: 64,
                top: 112,
                child: Image.asset('assets/images/eye_hero.png', width: 200, fit: BoxFit.contain),
),
        const Positioned(left: 8, top: 65, child: _Chip(Icons.remove_red_eye_outlined, 'Eyes')),
        const Positioned(left: 235, top: 99, child: _Chip(Icons.person_outline, 'Head')),
        const Positioned(left: 211, top: 291, child: _Chip(Icons.smartphone_outlined, 'Phone')),
      ],
    );
  }
}

class _AlertHero extends StatelessWidget {
  const _AlertHero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '2s',
            style: GoogleFonts.inter(
              fontSize: 140,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 320,
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 6,
                        right: 16,
                        child: Container(height: 2, color: AppColors.borderStrong),
                      ),
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                              color: AppColors.textSecondary, shape: BoxShape.circle),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                              color: Color(0xFFD32F2F), shape: BoxShape.circle),
                          child: const Icon(Icons.volume_up, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Eyes close', style: AppText.caption),
                    Text('Alarm', style: AppText.caption.copyWith(color: AppColors.danger)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyHero extends StatelessWidget {
  const _PrivacyHero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: Color(0xFF2E7D32), shape: BoxShape.circle),
            child: const Icon(Icons.lock_outline, size: 22, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Container(
            width: 296,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Column(
              children: const [
                _InfoRow(
                  icon: Icons.photo_camera_outlined,
                  title: 'Video',
                  statusIcon: Icons.lock_outline,
                  status: 'Stays on phone',
                  statusColor: AppColors.safe,
                ),
                Divider(height: 1, thickness: 1, color: Color(0xFF2A2A2A)),
                _InfoRow(
                  icon: Icons.alt_route,
                  title: 'Trip summary',
                  statusIcon: Icons.check_circle_outline,
                  status: 'Uploaded',
                  statusColor: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final IconData statusIcon;
  final String status;
  final Color statusColor;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.statusIcon,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Icon(icon, size: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Text(title, style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Icon(statusIcon, size: 12, color: statusColor),
          const SizedBox(width: 4),
          Text(status, style: AppText.caption.copyWith(color: statusColor)),
        ],
      ),
    );
  }
}