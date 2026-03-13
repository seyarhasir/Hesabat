import 'package:drift/drift.dart';

@DataClassName('ExchangeRate')
class ExchangeRates extends Table {
  TextColumn get id => text().clientDefault(() => 'rate_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}')();
  TextColumn get fromCurrency => text().named('from_currency')();
  TextColumn get toCurrency => text().named('to_currency')();
  RealColumn get rate => real()();
  DateTimeColumn get fetchedAt => dateTime().named('fetched_at').clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
