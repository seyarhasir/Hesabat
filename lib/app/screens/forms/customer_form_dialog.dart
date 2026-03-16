import 'package:flutter/material.dart';

class CustomerFormInput {
  final String name;
  final String? phone;
  final double totalOwed;

  const CustomerFormInput({
    required this.name,
    required this.phone,
    required this.totalOwed,
  });
}

Future<CustomerFormInput?> showCustomerFormDialog(
  BuildContext context, {
  CustomerFormInput initial = const CustomerFormInput(
    name: '',
    phone: null,
    totalOwed: 0,
  ),
  String title = 'Add Customer',
}) async {
  final nameController = TextEditingController(text: initial.name);
  final phoneController = TextEditingController(text: initial.phone ?? '');
  final owedController = TextEditingController(text: initial.totalOwed.toString());

  return showDialog<CustomerFormInput>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone (optional)'),
            ),
            TextField(
              controller: owedController,
              decoration: const InputDecoration(labelText: 'Total Owed'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final owed = double.tryParse(owedController.text.trim()) ?? 0;

              if (name.isEmpty) {
                return;
              }

              Navigator.of(context).pop(
                CustomerFormInput(
                  name: name,
                  phone: phone.isEmpty ? null : phone,
                  totalOwed: owed,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
