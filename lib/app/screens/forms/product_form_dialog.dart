import 'package:flutter/material.dart';

class ProductFormInput {
  final String name;
  final double price;
  final double stockQuantity;

  const ProductFormInput({
    required this.name,
    required this.price,
    required this.stockQuantity,
  });
}

Future<ProductFormInput?> showProductFormDialog(
  BuildContext context, {
  ProductFormInput initial = const ProductFormInput(
    name: '',
    price: 0,
    stockQuantity: 0,
  ),
  String title = 'Add Product',
}) async {
  final nameController = TextEditingController(text: initial.name);
  final priceController = TextEditingController(text: initial.price.toString());
  final stockController = TextEditingController(text: initial.stockQuantity.toString());

  return showDialog<ProductFormInput>(
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
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stock Quantity'),
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
              final price = double.tryParse(priceController.text.trim()) ?? 0;
              final stock = double.tryParse(stockController.text.trim()) ?? 0;

              if (name.isEmpty) {
                return;
              }

              Navigator.of(context).pop(
                ProductFormInput(
                  name: name,
                  price: price,
                  stockQuantity: stock,
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
