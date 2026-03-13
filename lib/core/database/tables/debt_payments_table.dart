import 'package:drift/drift.dart';

@DataClassName('DebtPayment')
class DebtPayments extends Table {
  TextColumn get id => text().clientDefault(() => 'local_pay_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get debtId => text().named('debt_id')();
  TextColumn get shopId => text().named('shop_id')();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text().named('payment_method').withDefault(const Constant('cash'))();
  TextColumn get currency => text().withDefault(const Constant('AFN'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
