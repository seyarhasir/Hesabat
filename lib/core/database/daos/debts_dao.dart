import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/debts_table.dart';
import '../tables/debt_payments_table.dart';

part 'debts_dao.g.dart';

@DriftAccessor(tables: [Debts, DebtPayments])
class DebtsDao extends DatabaseAccessor<AppDatabase> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<List<Debt>> getAllDebts() => select(debts).get();

  Future<List<Debt>> getDebtsByShopId(String shopId) =>
      (select(debts)..where((d) => d.shopId.equals(shopId))).get();

  Future<Debt?> getDebtById(String id) =>
      (select(debts)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<int> insertDebt(DebtsCompanion debt) => into(debts).insert(debt);

  Future<bool> updateDebt(DebtsCompanion debt) => update(debts).replace(debt);

  Future<int> deleteDebt(String id) =>
      (delete(debts)..where((d) => d.id.equals(id))).go();

  Stream<List<Debt>> watchDebtsByShopId(String shopId) =>
      (select(debts)..where((d) => d.shopId.equals(shopId))).watch();

  Future<List<Debt>> getDebtsByCustomer(String customerId) =>
      (select(debts)
        ..where((d) => d.customerId.equals(customerId))
        ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
          .get();

  Future<List<Debt>> getOpenDebts(String shopId) =>
      (select(debts)
        ..where((d) => d.shopId.equals(shopId) & d.status.equals('open'))
        ..orderBy([(d) => OrderingTerm.desc(d.amountRemaining)]))
          .get();

  Future<List<Debt>> getOverdueDebts(String shopId, DateTime before) =>
      (select(debts)
        ..where((d) =>
            d.shopId.equals(shopId) &
            d.status.equals('open') &
            d.createdAt.isSmallerThanValue(before)))
          .get();

  // Debt Payments
  Future<List<DebtPayment>> getDebtPayments(String debtId) =>
      (select(debtPayments)..where((dp) => dp.debtId.equals(debtId))).get();

  Future<List<DebtPayment>> getPaymentsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(debtPayments)
        ..where((dp) => dp.createdAt.isBetweenValues(start, end)))
          .get();

  Future<List<DebtPayment>> getDebtPaymentsByShopId(String shopId) =>
      (select(debtPayments)..where((dp) => dp.shopId.equals(shopId))).get();

  Future<int> insertDebtPayment(DebtPaymentsCompanion payment) =>
      into(debtPayments).insert(payment);

  Future<double> getTotalPaidForDebt(String debtId) async {
    final result = await customSelect(
      'SELECT SUM(amount) as total FROM debt_payments WHERE debt_id = ?',
      variables: [Variable.withString(debtId)],
    ).getSingleOrNull();

    return result?.data['total'] as double? ?? 0.0;
  }

  // Record payment and update debt
  Future<void> recordPayment(
    String debtId,
    DebtPaymentsCompanion payment,
    double newRemaining,
    String newStatus,
  ) async {
    await transaction(() async {
      await into(debtPayments).insert(payment);
      await (update(debts)..where((d) => d.id.equals(debtId))).write(
        DebtsCompanion(
          amountPaid: Value(await getTotalPaidForDebt(debtId)),
          amountRemaining: Value(newRemaining),
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<double> getTotalOutstanding(String shopId) async {
    final result = await customSelect(
      'SELECT SUM(amount_remaining) as total FROM debts WHERE shop_id = ? AND status IN (\'open\', \'partial\')',
      variables: [Variable.withString(shopId)],
    ).getSingleOrNull();

    return result?.data['total'] as double? ?? 0.0;
  }

  Future<int> updateSyncStatus(String id, String status) =>
      (update(debts)..where((d) => d.id.equals(id))).write(
        DebtsCompanion(syncStatus: Value(status)),
      );

  Future<int> markAsSynced(String id) =>
      (update(debts)..where((d) => d.id.equals(id))).write(
        DebtsCompanion(
          syncStatus: const Value('synced'),
          syncedAt: Value(DateTime.now()),
        ),
      );
}
