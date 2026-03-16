import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/sync_usecase_providers.dart';
import '../actions/customer_write_actions.dart';
import 'forms/customer_form_dialog.dart';
import '../read_models/read_model_providers.dart';
import '../router/app_routes.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersReadModelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
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
          final form = await showCustomerFormDialog(context);
          if (form == null) return;

          final ok = await ref.read(customerWriteActionsProvider).addOrUpdateCustomer(
                name: form.name,
                phone: form.phone,
                totalOwed: form.totalOwed,
              );

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ok
                  ? 'Customer saved locally and queued for sync.'
                  : 'Missing active shop/device context.'),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Customer'),
      ),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load customers: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No customers in local cache'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = items[i];
              return ListTile(
                title: Text(c.name),
                subtitle: Text(c.phone ?? 'No phone'),
                trailing: Text('Debt: ${c.totalOwed.toStringAsFixed(2)}'),
                onTap: () async {
                  final form = await showCustomerFormDialog(
                    context,
                    initial: CustomerFormInput(
                      name: c.name,
                      phone: c.phone,
                      totalOwed: c.totalOwed,
                    ),
                    title: 'Edit Customer',
                  );
                  if (form == null) return;

                  final ok = await ref.read(customerWriteActionsProvider).addOrUpdateCustomer(
                        customerId: c.id,
                        name: form.name,
                        phone: form.phone,
                        totalOwed: form.totalOwed,
                      );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Customer updated and queued.' : 'Update failed.')),
                  );
                },
                onLongPress: () async {
                  final ok = await ref
                      .read(customerWriteActionsProvider)
                      .deleteCustomer(customerId: c.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? 'Customer deleted and queued.' : 'Delete failed.')),
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
