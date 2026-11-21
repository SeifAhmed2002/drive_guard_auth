import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'core/theme.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const DriveGuardApp());
}

class DriveGuardApp extends StatelessWidget {
  const DriveGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Guard',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const OnboardingScreen(),
    );
  }
}
