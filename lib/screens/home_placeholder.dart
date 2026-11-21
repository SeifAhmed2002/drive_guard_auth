import 'package:material_ui/material_ui.dart';

import '../core/theme.dart';
import '../services/auth_service.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';

/// Temporary landing screen after sign in. Replace with the real
/// Permissions / Home screens of the next tasks.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text("You're in", style: AppText.h1),
              const SizedBox(height: AppSpace.xs),
              Text('Authentication finished. Next: Permissions screen.', style: AppText.bodySecondary),
              const Spacer(),
              PrimaryButton(
                label: 'Sign out',
                onPressed: () async {
                  await authService.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
