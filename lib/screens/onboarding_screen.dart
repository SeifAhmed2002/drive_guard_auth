import 'package:material_ui/material_ui.dart';

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

  static const _slides = <_Slide>[
    _Slide(
      'Stay alert on every drive',
      "Your phone's front camera watches your eyes, head and hands while you drive.",
      _WatchHero(),
    ),
    _Slide(
      'An alarm within 2 seconds',
      'Eyes closing, head nodding or a phone in your hand triggers a loud alarm right away.',
      _AlertHero(),
    ),
    _Slide(
      'No video leaves your phone',
      'Video is checked on your phone and never saved. Only the trip summary is uploaded.',
      _PrivacyHero(),
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
                          child: Text('Skip', style: AppText.labelLarge.copyWith(color: AppColors.textSecondary)),
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
                      Expanded(child: Center(child: FittedBox(fit: BoxFit.contain, child: SizedBox(width: 360, height: 360, child: s.hero)))),
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
                  PrimaryButton(label: _isLast ? 'Create account' : 'Next', onPressed: _next),
                  if (_isLast) ...[
                    const SizedBox(height: AppSpace.xs),
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _goLogin,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Wrap(
                            spacing: AppSpace.xxs,
                            children: [
                              Text('Already have an account?', style: AppText.bodySecondary),
                              Text('Sign in', style: AppText.labelLarge),
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

/// Active segment = 32 wide white, others = 16 wide grey.
class _StepBar extends StatelessWidget {
  final int index;
  final int count;
  const _StepBar({required this.index, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: i == count - 1 ? 0 : 6),
          width: active ? 32 : 16,
          height: 4,
          decoration: BoxDecoration(
            color: active ? AppColors.textPrimary : AppColors.borderStrong,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------- heroes
// Simplified 360x360 illustrations (rings + chips). Swap for exported
// Figma assets if you need pixel-perfect art.

class _Rings extends StatelessWidget {
  const _Rings();
  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(360, 360), painter: _RingsPainter());
}

class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final c = Offset(s.width / 2, s.height / 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.borderStrong.withValues(alpha: 0.6);
    for (final r in [190.0, 150.0, 110.0]) {
      canvas.drawCircle(c, r, p);
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
        color: AppColors.raised,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 3, backgroundColor: AppColors.safe),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(label, style: AppText.caption.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _WatchHero extends StatelessWidget {
  const _WatchHero();
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _Rings(),
        Positioned(left: 80, top: 117, child: EyeMark(width: 200, height: 125, tile: false)),
        Positioned(left: 24, top: 58, child: _Chip(Icons.remove_red_eye_outlined, 'Eyes')),
        Positioned(left: 252, top: 92, child: _Chip(Icons.person_outline, 'Head')),
        Positioned(left: 228, top: 284, child: _Chip(Icons.smartphone_outlined, 'Phone')),
      ],
    );
  }
}

class _AlertHero extends StatelessWidget {
  const _AlertHero();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const _Rings(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('2s', style: AppText.h1.copyWith(fontSize: 96, height: 1, letterSpacing: -2)),
            const SizedBox(height: AppSpace.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.danger),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.volume_up_outlined, size: 16, color: AppColors.danger),
                  const SizedBox(width: 6),
                  Text('Alarm', style: AppText.caption.copyWith(color: AppColors.danger)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrivacyHero extends StatelessWidget {
  const _PrivacyHero();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const _Rings(),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.safe.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.safe),
          ),
          child: const Icon(Icons.lock_outline, size: 40, color: AppColors.safe),
        ),
        const Positioned(left: 24, top: 58, child: _Chip(Icons.videocam_off_outlined, 'Video stays here')),
        const Positioned(left: 150, top: 284, child: _Chip(Icons.cloud_upload_outlined, 'Summary only')),
      ],
    );
  }
}
