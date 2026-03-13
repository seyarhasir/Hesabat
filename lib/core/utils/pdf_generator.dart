import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_report_base.dart';
import 'date_formatter.dart';

class PdfGenerator {
  PdfGenerator._();

  static Future<File> generateCustomerReportPdf({
    required int newCustomers,
    required int returningCustomers,
    required List<MapEntry<String, double>> topCustomers,
    required List<MapEntry<String, double>> atRiskCustomers,
    required List<String> purchaseHistory,
    CalendarType calendar = CalendarType.gregorian,
    String locale = 'fa',
  }) async {
    final pdf = PdfReportBase.createDocument();
    final moneyFmt = NumberFormat('#,##0.##');

    pw.Widget amountTable(String title, List<MapEntry<String, double>> rows) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          if (rows.isEmpty)
            pw.Text('No data', style: const pw.TextStyle(fontSize: 11))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Customer', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Amount (AFN)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...rows.map(
                  (e) => pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.key, style: const pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(moneyFmt.format(e.value), style: const pw.TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    }

    pdf.addPage(
      PdfReportBase.buildPage(
        titleEn: 'Customer Report',
        titleFa: 'گزارش مشتریان',
        calendar: calendar,
        locale: locale,
        children: [
          pw.Text('Hesabat - Customer Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _metricRow('New Customers', '$newCustomers'),
                _metricRow('Returning Customers', '$returningCustomers'),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          amountTable('Top Customers by Revenue', topCustomers),
          pw.SizedBox(height: 16),
          amountTable('At-Risk Customers', atRiskCustomers),
          pw.SizedBox(height: 16),
          pw.Text('Purchase History', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          if (purchaseHistory.isEmpty)
            pw.Text('No history', style: const pw.TextStyle(fontSize: 11))
          else
            ...purchaseHistory.map((line) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(line, style: const pw.TextStyle(fontSize: 11)),
                )),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hesabat_customer_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static Future<File> generateProfitReportPdf({
    required double revenue,
    required double cost,
    required double profit,
    required double profitMarginPct,
    required List<MapEntry<String, double>> trend,
    CalendarType calendar = CalendarType.gregorian,
    String locale = 'fa',
  }) async {
    final pdf = PdfReportBase.createDocument();
    final moneyFmt = NumberFormat('#,##0.##');

    pdf.addPage(
      PdfReportBase.buildPage(
        titleEn: 'Profit Report',
        titleFa: 'گزارش سود',
        calendar: calendar,
        locale: locale,
        children: [
          pw.Text('Hesabat - Profit Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _metricRow('Revenue', '${moneyFmt.format(revenue)} AFN'),
                _metricRow('Cost (COGS)', '${moneyFmt.format(cost)} AFN'),
                _metricRow('Profit', '${moneyFmt.format(profit)} AFN'),
                _metricRow('Profit Margin', '${profitMarginPct.toStringAsFixed(1)}%'),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Profit Trend', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          if (trend.isEmpty)
            pw.Text('No trend data', style: const pw.TextStyle(fontSize: 11))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Month', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Profit (AFN)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...trend.map(
                  (e) => pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(e.key, style: const pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(moneyFmt.format(e.value), style: const pw.TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hesabat_profit_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static Future<File> generateInventoryReportPdf({
    required double inventoryValue,
    required int totalProducts,
    required int lowStockCount,
    required List<MapEntry<String, double>> categoryBreakdown,
    required List<MapEntry<String, double>> fastMovers,
    required List<MapEntry<String, double>> slowMovers,
    CalendarType calendar = CalendarType.gregorian,
    String locale = 'fa',
  }) async {
    final pdf = PdfReportBase.createDocument();
    final moneyFmt = NumberFormat('#,##0.##');

    pw.Widget productTable(String title, List<MapEntry<String, double>> rows, String valueLabel) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          if (rows.isEmpty)
            pw.Text('No data', style: const pw.TextStyle(fontSize: 11))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(valueLabel, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...rows.map(
                  (r) => pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(r.key, style: const pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(r.value.toStringAsFixed(0), style: const pw.TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      );
    }

    pdf.addPage(
      PdfReportBase.buildPage(
        titleEn: 'Inventory Report',
        titleFa: 'گزارش موجودی',
        calendar: calendar,
        locale: locale,
        children: [
          pw.Text('Hesabat - Inventory Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _metricRow('Inventory Value', '${moneyFmt.format(inventoryValue)} AFN'),
                _metricRow('Total Products', '$totalProducts'),
                _metricRow('Low Stock Items', '$lowStockCount'),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          productTable('Category Breakdown', categoryBreakdown, 'Products'),
          pw.SizedBox(height: 16),
          productTable('Fast Movers (30d)', fastMovers, 'Qty Sold'),
          pw.SizedBox(height: 16),
          productTable('Slow Movers (30d)', slowMovers, 'Qty Sold'),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hesabat_inventory_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static Future<File> generateSalesReportPdf({
    required DateTime startDate,
    required DateTime endDate,
    required double totalRevenue,
    required int transactionCount,
    required double averageSale,
    required double cashSales,
    required double creditSales,
    required double mixedSales,
    required List<MapEntry<String, int>> topProducts,
    CalendarType calendar = CalendarType.gregorian,
    String locale = 'fa',
  }) async {
    final pdf = PdfReportBase.createDocument();
    final moneyFmt = NumberFormat('#,##0.##');

    pw.Widget metricRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );
    }

    pdf.addPage(
      PdfReportBase.buildPage(
        titleEn: 'Sales Report',
        titleFa: 'گزارش فروش',
        calendar: calendar,
        locale: locale,
        children: [
          pw.Text('Hesabat - Sales Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.Text('Period: ${DateFormatter.formatDate(startDate, calendar: calendar, locale: locale)} - ${DateFormatter.formatDate(endDate, calendar: calendar, locale: locale)}', style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                metricRow('Total Revenue', '${moneyFmt.format(totalRevenue)} AFN'),
                metricRow('Transactions', '$transactionCount'),
                metricRow('Average Sale', '${moneyFmt.format(averageSale)} AFN'),
                metricRow('Cash Sales', '${moneyFmt.format(cashSales)} AFN'),
                metricRow('Credit (Qarz)', '${moneyFmt.format(creditSales)} AFN'),
                metricRow('Mixed', '${moneyFmt.format(mixedSales)} AFN'),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          pw.Text('Top Products', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          if (topProducts.isEmpty)
            pw.Text('No product data', style: const pw.TextStyle(fontSize: 12))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Product', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...topProducts.map(
                  (p) => pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(p.key, style: const pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${p.value}', style: const pw.TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hesabat_sales_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static Future<File> generateQarzReportPdf({
    required double totalOutstanding,
    required int openDebts,
    required int overdueDebts,
    required List<MapEntry<String, double>> topDebtors,
    CalendarType calendar = CalendarType.gregorian,
    String locale = 'fa',
  }) async {
    final pdf = PdfReportBase.createDocument();
    final moneyFmt = NumberFormat('#,##0.##');

    pdf.addPage(
      PdfReportBase.buildPage(
        titleEn: 'Qarz Report',
        titleFa: 'گزارش قرض',
        calendar: calendar,
        locale: locale,
        children: [
          pw.Text('Hesabat - Qarz Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _metricRow('Total Outstanding', '${moneyFmt.format(totalOutstanding)} AFN'),
                _metricRow('Open Debts', '$openDebts'),
                _metricRow('Overdue (30+ days)', '$overdueDebts'),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          pw.Text('Top Debtors', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          if (topDebtors.isEmpty)
            pw.Text('No debtor data', style: const pw.TextStyle(fontSize: 12))
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Customer', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Amount (AFN)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  ],
                ),
                ...topDebtors.map(
                  (p) => pw.TableRow(
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(p.key, style: const pw.TextStyle(fontSize: 11))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(moneyFmt.format(p.value), style: const pw.TextStyle(fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/hesabat_qarz_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  static pw.Widget _metricRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
