class ProductReadModel {
  final String id;
  final String shopId;
  final String name;
  final double price;
  final double stockQuantity;
  final DateTime? updatedAt;

  const ProductReadModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.updatedAt,
  });
}
