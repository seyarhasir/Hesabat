import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/theme/app_colors.dart';

class FirstProductScreen extends ConsumerStatefulWidget {
  const FirstProductScreen({super.key});

  @override
  ConsumerState<FirstProductScreen> createState() => _FirstProductScreenState();
}

class _FirstProductScreenState extends ConsumerState<FirstProductScreen> {
  int _addedProducts = 0;
  final int _maxProducts = 3;

  void _onAddProduct(String method) {
    setState(() => _addedProducts++);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final stepText = NumberSystemFormatter.apply('Step 4 of 4');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: 1.0, minHeight: 4),
              ),
              const SizedBox(height: 8),
              Text(stepText, style: theme.textTheme.bodySmall),

              const SizedBox(height: 24),

              Text('Add Products', style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text(NumberSystemFormatter.apply('Add up to 3 products to start. More later.'), style: theme.textTheme.bodyMedium),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: _maxProducts,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final isFilled = i < _addedProducts;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isFilled ? AppColors.success.withOpacity(0.05) : cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isFilled ? AppColors.success.withOpacity(0.3) : cs.outline,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? AppColors.success.withOpacity(0.1)
                                  : cs.secondary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isFilled ? Icons.check_rounded : Icons.add_rounded,
                              color: isFilled ? AppColors.success : cs.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isFilled
                                      ? 'Product ${NumberSystemFormatter.apply('${i + 1}')} Added'
                                      : 'Product ${NumberSystemFormatter.apply('${i + 1}')}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                if (!isFilled)
                                  Text('Tap + to add', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          if (!isFilled)
                            IconButton(
                              onPressed: _showAddOptions,
                              icon: Icon(Icons.add_circle_rounded, color: cs.primary),
                              iconSize: 32,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text('Skip for now'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: _addedProducts > 0 ? 'Complete Setup' : 'Start Using App',
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Product',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner_rounded),
              title: const Text('Scan Barcode'),
              subtitle: const Text('Use camera to scan'),
              onTap: () { Navigator.pop(context); _onAddProduct('barcode'); },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Manual Entry'),
              subtitle: const Text('Type product details'),
              onTap: () { Navigator.pop(context); _onAddProduct('manual'); },
            ),
          ],
        ),
      ),
    );
  }
}
