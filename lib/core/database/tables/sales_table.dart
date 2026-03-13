import 'package:drift/drift.dart';

@DataClassName('Sale')
class Sales extends Table {
  TextColumn get id => text().clientDefault(() => 'local_sale_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get customerId => text().named('customer_id').nullable()();
  RealColumn get totalAmount => real().named('total_amount')();
  RealColumn get totalAfn => real().named('total_afn')();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().named('payment_method').withDefault(const Constant('cash'))();
  TextColumn get currency => text().withDefault(const Constant('AFN'))();
  RealColumn get exchangeRate => real().named('exchange_rate').withDefault(const Constant(1.0))();
  BoolColumn get isCredit => boolean().named('is_credit').withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  BoolColumn get createdOffline => boolean().named('created_offline').withDefault(const Constant(false))();
  TextColumn get localId => text().named('local_id').nullable()();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
