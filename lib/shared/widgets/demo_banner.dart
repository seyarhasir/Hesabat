import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/utils/number_system_formatter.dart';
import '../theme/app_colors.dart';

class DemoBanner extends ConsumerWidget implements PreferredSizeWidget {
  const DemoBanner({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    if (!authState.isGuest) return const SizedBox.shrink();

    final limits = authState.guestLimits;
    final productsRemaining = limits?['productsRemaining'] ?? 0;
    final salesRemaining = limits?['salesRemaining'] ?? 0;
    final productsText = NumberSystemFormatter.formatFixed(productsRemaining);
    final salesText = NumberSystemFormatter.formatFixed(salesRemaining);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.warning,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'DEMO — $productsText products, $salesText sales left',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => _showUpgradeDialog(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'UPGRADE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Full Access'),
        content: const Text(
          'Contact our sales team to get full access to Hesabat:\n\n'
          '• Unlimited products and sales\n'
          '• Cloud sync across devices\n'
          '• WhatsApp integration\n'
          '• Priority support\n\n'
          'Phone: +93 70 000 0000',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Contact Sales'),
          ),
        ],
      ),
    );
  }
}

class DemoBannerWrapper extends ConsumerWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DemoBannerWrapper({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: authState.isGuest
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                (appBar?.preferredSize.height ?? 0) + 40,
              ),
              child: Column(
                children: [
                  const DemoBanner(),
                  if (appBar != null) appBar!,
                ],
              ),
            )
          : appBar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
