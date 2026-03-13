import 'package:drift/drift.dart';
import 'shops_table.dart';

@DataClassName('Product')
class Products extends Table {
  TextColumn get id => text().clientDefault(() => 'local_prod_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id').references(Shops, #id, onDelete: KeyAction.cascade)();
  TextColumn get nameDari => text().named('name_dari')();
  TextColumn get namePashto => text().named('name_pashto').nullable()();
  TextColumn get nameEn => text().named('name_en').nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  RealColumn get costPrice => real().named('cost_price').nullable()();
  RealColumn get stockQuantity => real().named('stock_quantity').withDefault(const Constant(0.0))();
  RealColumn get minStockAlert => real().named('min_stock_alert').withDefault(const Constant(5.0))();
  TextColumn get unit => text().withDefault(const Constant('piece'))();
  TextColumn get categoryId => text().named('category_id').nullable()();
  TextColumn get imageUrl => text().named('image_url').nullable()();
  DateTimeColumn get expiryDate => dateTime().named('expiry_date').nullable()();
  BoolColumn get prescriptionRequired => boolean().named('prescription_required').withDefault(const Constant(false))();
  TextColumn get dosage => text().nullable()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get sizeVariant => text().named('size_variant').nullable()();
  TextColumn get imei => text().nullable()();
  TextColumn get serialNumber => text().named('serial_number').nullable()();
  RealColumn get weightGrams => real().named('weight_grams').nullable()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  TextColumn get localId => text().named('local_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
