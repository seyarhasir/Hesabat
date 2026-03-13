import 'package:drift/drift.dart';

@DataClassName('Shop')
class Shops extends Table {
  TextColumn get id => text().clientDefault(() => 'local_${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get ownerId => text().named('owner_id')();
  TextColumn get name => text()();
  TextColumn get nameDari => text().named('name_dari').nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get city => text().withDefault(const Constant('Kabul'))();
  TextColumn get district => text().nullable()();
  TextColumn get shopType => text().named('shop_type').withDefault(const Constant('general'))();
  TextColumn get currencyPref => text().named('currency_pref').withDefault(const Constant('AFN'))();
  TextColumn get languagePref => text().named('language_pref').withDefault(const Constant('fa'))();
  TextColumn get subscriptionStatus => text().named('subscription_status').withDefault(const Constant('trial'))();
  DateTimeColumn get trialEndsAt => dateTime().named('trial_ends_at').clientDefault(() => DateTime.now().add(const Duration(days: 30)))();
  DateTimeColumn get subscriptionEndsAt => dateTime().named('subscription_ends_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').clientDefault(() => DateTime.now())();
  
  // Sync status for offline-first
  TextColumn get syncStatus => text().named('sync_status').withDefault(const Constant('pending'))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
