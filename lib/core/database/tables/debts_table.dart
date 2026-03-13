import 'package:drift/drift.dart';

@DataClassName('Debt')
class Debts extends Table {
  TextColumn get id => text().clientDefault(() => 'local_debt_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get shopId => text().named('shop_id')();
  TextColumn get customerId => text().named('customer_id')();
  TextColumn get saleId => text().named('sale_id').nullable()();
  RealColumn get amountOriginal => real().named('amount_original')();
  RealColumn get amountPaid => real().named('amount_paid').withDefault(const Constant(0.0))();
  RealColumn get amountRemaining => real().named('amount_remaining').withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  DateTimeColumn get lastReminderSentAt => dateTime().named('last_reminder_sent_at').nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').clientDefault(() => DateTime.now())();
  
  // Sync status
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
