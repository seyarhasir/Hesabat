import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../actions/product_write_actions.dart';
import 'forms/product_form_dialog.dart';
import '../read_models/read_model_providers.dart';
import '../router/app_routes.dart';
import '../../../shared/widgets/currency_display.dart';
import '../../domain/usecases/sync_usecase_providers.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsReadModelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              final result = await ref.read(runPendingSyncProvider).call(batchLimit: 100);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sync: ${result.outcome.name} | ok: ${result.succeeded} | fail: ${result.failed}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final form = await showProductFormDialog(context);
          if (form == null) return;

          final ok = await ref.read(productWriteActionsProvider).addOrUpdateProduct(
                name: form.name,
                price: form.price,
                stockQuantity: form.stockQuantity,
              );

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ok
                  ? 'Product saved locally and queued for sync.'
                  : 'Missing active shop/device context.'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load products: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No products in local cache'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final p = items[i];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('Stock: ${p.stockQuantity}'),
                trailing: CurrencyDisplay(amount: p.price),
                onTap: () async {
                  final form = await showProductFormDialog(
                    context,
                    initial: ProductFormInput(
                      name: p.name,
                      price: p.price,
                      stockQuantity: p.stockQuantity,
                    ),
                    title: 'Edit Product',
                  );
                  if (form == null) return;

                  final ok = await ref.read(productWriteActionsProvider).addOrUpdateProduct(
                        productId: p.id,
                        name: form.name,
                        price: form.price,
                        stockQuantity: form.stockQuantity,
                      );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Product updated and queued.' : 'Update failed.')),
                  );
                },
                onLongPress: () async {
                  final ok = await ref
                      .read(productWriteActionsProvider)
                      .deleteProduct(productId: p.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Product deleted and queued.' : 'Delete failed.')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
