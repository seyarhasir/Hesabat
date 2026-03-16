class CustomerReadModel {
  final String id;
  final String shopId;
  final String name;
  final String? phone;
  final double totalOwed;
  final DateTime? updatedAt;

  const CustomerReadModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.phone,
    required this.totalOwed,
    required this.updatedAt,
  });
}
