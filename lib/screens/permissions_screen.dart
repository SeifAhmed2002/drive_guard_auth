import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/permission_service.dart';
import '../widgets/primary_button.dart';
import 'home_placeholder.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _camera = false;
  bool _location = false;
  bool _busyCamera = false;
  bool _busyLocation = false;

  bool get _canContinue => _camera && _location;

  @override
  void initState() {
    super.initState();
    _askCamera(); // the design asks for the camera as soon as the screen opens
  }

  Future<void> _askCamera() async {
    setState(() => _busyCamera = true);
    final ok = await permissionService.requestCamera();
    if (!mounted) return;
    setState(() {
      _camera = ok;
      _busyCamera = false;
    });
  }

  Future<void> _askLocation() async {
    setState(() => _busyLocation = true);
    final ok = await permissionService.requestLocation();
    if (!mounted) return;
    setState(() {
      _location = ok;
      _busyLocation = false;
    });
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location is needed to show where each alert happened.')),
      );
    }
  }

  void _continue() {
    // Next screen in the design: 07 Calibration (not built yet).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePlaceholderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.md, AppSpace.xl, AppSpace.md, AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Two permissions to keep you safe', style: AppText.h1),
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        'We ask once. You can change this later in Settings.',
                        style: AppText.bodySecondary,
                      ),
                      const SizedBox(height: AppSpace.lg),
                      _PermissionCard(
                        icon: Icons.photo_camera_outlined,
                        title: 'Camera',
                        description:
                            'Watches your eyes and head to spot drowsiness and phone use. Video stays on this phone.',
                        allowed: _camera,
                      ),
                      const SizedBox(height: AppSpace.md),
                      _PermissionCard(
                        icon: Icons.location_on_outlined,
                        title: 'Location (GPS)',
                        description:
                            'Records your route so your trip summary shows where each alert happened.',
                        allowed: _location,
                      ),
                      const SizedBox(height: AppSpace.md),
                      if (!_camera) ...[
                        _AllowButton(
                          icon: Icons.photo_camera_outlined,
                          label: 'Allow camera',
                          busy: _busyCamera,
                          onPressed: _askCamera,
                        ),
                        const SizedBox(height: AppSpace.sm),
                      ],
                      if (!_location) ...[
                        _AllowButton(
                          icon: Icons.location_on_outlined,
                          label: 'Allow location',
                          busy: _busyLocation,
                          onPressed: _askLocation,
                        ),
                        const SizedBox(height: AppSpace.sm),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.lock_outline, size: 20, color: AppColors.safe),
                          const SizedBox(width: AppSpace.sm),
                          Text('Video never leaves this phone.', style: AppText.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              PrimaryButton(label: 'Continue', onPressed: _canContinue ? _continue : null),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool allowed;
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.allowed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: allowed ? AppColors.safe : const Color(0xFF2A2A2A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.raised,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpace.xxs),
                Text(description, style: AppText.bodySmall),
                const SizedBox(height: AppSpace.xs),
                _StatusBadge(allowed: allowed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool allowed;
  const _StatusBadge({required this.allowed});

  @override
  Widget build(BuildContext context) {
    final bg = allowed ? const Color(0xFF2E7D32) : const Color(0xFFFFA726);
    final fg = allowed ? Colors.white : AppColors.onAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            allowed ? 'Allowed' : 'Required',
            style: AppText.label.copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          Icon(allowed ? Icons.check_circle : Icons.warning_amber_rounded, size: 16, color: fg),
        ],
      ),
    );
  }
}

class _AllowButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool busy;
  final VoidCallback onPressed;
  const _AllowButton({
    required this.icon,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.raised,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.raised,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF333333)),
          ),
        ),
        child: busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpace.xs),
                  Text(label, style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }
}