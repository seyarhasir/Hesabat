import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_state_notifier.dart';
import '../read_models/read_model_providers.dart';
import '../router/app_routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateNotifierProvider);
    final products = ref.watch(productsReadModelsProvider);
    final customers = ref.watch(customersReadModelsProvider);

    final productsCount = products.valueOrNull?.length ?? 0;
    final customersCount = customers.valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Authenticated shop: ${auth.shopId ?? 'unknown'}'),
            const SizedBox(height: 16),
            Text('Products cached: $productsCount'),
            Text('Customers cached: $customersCount'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.products),
              child: const Text('Open Products'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.customers),
              child: const Text('Open Customers'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.status == AuthStatus.refreshing
                    ? null
                    : () async {
                        await ref.read(authStateNotifierProvider.notifier).signOutAtomic();
                      },
                child: Text(
                  auth.status == AuthStatus.refreshing ? 'Signing out...' : 'Sign Out',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
