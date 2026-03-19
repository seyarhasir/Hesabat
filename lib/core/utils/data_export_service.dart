import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:intl/intl.dart' as intl;

import '../database/app_database.dart';
import '../settings/shop_profile_service.dart';
import 'date_formatter.dart';
import 'number_system_formatter.dart';

class DataExportService {
  static Future<void> exportAllDataToSingleCsv({
    required String shopName,
    required List<Product> products,
    required List<Customer> customers,
    required List<Sale> sales,
    required List<SaleItem> saleItems,
    required List<Debt> debts,
    required List<DebtPayment> debtPayments,
    required String lang,
  }) async {
    final List<List<dynamic>> rows = [];
    
    String _tr(String en, String fa) => lang == 'fa' || lang == 'ps' ? fa : en;

    // 1. Header
    rows.add(['HESABAT - $shopName - ${DateTime.now().toString()}']);
    rows.add([]);

    // 2. Inventory Section
    rows.add(['--- ${_tr('INVENTORY / PRODUCTS', 'موجودی / محصولات')} ---']);
    rows.add(['Name (Dari)', 'Name (Pashto)', 'Name (En)', 'Barcode', 'Stock', 'Price', 'Cost Price', 'Total Value', 'Potential Profit']);
    for (var p in products) {
      final totalValue = p.stockQuantity * p.price;
      final potentialProfit = p.stockQuantity * (p.price - (p.costPrice ?? 0.0));
      rows.add([
        p.nameDari, 
        p.namePashto ?? '', 
        p.nameEn ?? '', 
        p.barcode ?? '', 
        p.stockQuantity, 
        p.price, 
        p.costPrice ?? 0.0,
        totalValue,
        potentialProfit,
      ]);
    }
    rows.add([]);

    // 3. Customers Section
    rows.add(['--- ${_tr('CUSTOMERS & DEBTS', 'مشتریان و بدهی‌ها')} ---']);
    rows.add(['Name', 'Phone', 'Total Owed']);
    for (var c in customers) {
      rows.add([c.name, c.phone ?? '', c.totalOwed]);
    }
    rows.add([]);

    // 4. Sales History Section
    final itemsMap = <String, List<SaleItem>>{};
    for (var item in saleItems) {
      itemsMap.putIfAbsent(item.saleId, () => []).add(item);
    }
    
    // Map product costs for profit calculation
    final productCosts = {for (var p in products) p.id: p.costPrice ?? 0.0};
    final customerMap = {for (var c in customers) c.id: c.name};

    rows.add(['--- ${_tr('SALES HISTORY', 'تاریخچه فروش')} ---']);
    rows.add(['Date', 'Customer', 'Total', 'Payment Method', 'Items Sold', 'Profit']);
    for (var s in sales) {
      final items = itemsMap[s.id] ?? [];
      final itemSummary = items.map((i) => '${i.quantity}x ${i.productNameSnapshot}').join(', ');
      
      double saleProfit = 0;
      for (var item in items) {
        if (item.productId != null) {
          final cost = productCosts[item.productId] ?? 0.0;
          saleProfit += (item.unitPrice - cost) * item.quantity;
        }
      }

      rows.add([
        s.createdAt.toString(),
        customerMap[s.customerId] ?? s.customerId ?? '-',
        s.totalAmount,
        s.paymentMethod,
        itemSummary,
        saleProfit,
      ]);
    }
    rows.add([]);

    // 5. Debt History Section
    rows.add(['--- ${_tr('DEBT HISTORY (LEGGER)', 'تاریخچه بدهی‌ها')} ---']);
    rows.add(['Date', 'Customer', 'Type', 'Amount', 'Notes']);
    
    // Combine debts and payments for a chronological ledger
    for (var d in debts) {
      rows.add([
        d.createdAt.toString(),
        customerMap[d.customerId] ?? d.customerId,
        _tr('NEW DEBT', 'بدهی جدید'),
        d.amountOriginal,
        d.notes ?? '',
      ]);
    }
    for (var dp in debtPayments) {
      // Find debt to get customer
      final debt = debts.cast<Debt?>().firstWhere((d) => d?.id == dp.debtId, orElse: () => null);
      rows.add([
        dp.createdAt.toString(),
        customerMap[debt?.customerId] ?? debt?.customerId ?? '-',
        _tr('PAYMENT', 'پرداخت بدهی'),
        dp.amount,
        dp.notes ?? '',
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/hesabat_full_export_${DateTime.now().millisecondsSinceEpoch}.csv");
    
    // Add UTF-8 BOM for Excel compatibility with Persian/Pashto
    final bytes = [0xEF, 0xBB, 0xBF, ...utf8.encode(csvData)];
    await file.writeAsBytes(bytes);
    
    await Share.shareXFiles([XFile(file.path)], text: 'Full Business Export from Hesabat');
  }

  static Future<void> exportToPdf({
    required List<Product> products,
    required List<Customer> customers,
    required List<Sale> sales,
    required List<SaleItem> saleItems,
    required List<Debt> debts,
    required List<DebtPayment> debtPayments,
    required String lang,
  }) async {
    final pdf = pw.Document();
    
    // Load fonts
    final fontData = await rootBundle.load("assets/fonts/Vazirmatn-Regular.ttf");
    final font = pw.Font.ttf(fontData);
    final boldData = await rootBundle.load("assets/fonts/Vazirmatn-Bold.ttf");
    final boldFont = pw.Font.ttf(boldData);

    final profile = await ShopProfileService.loadWithCloudFallback();
    final shopName = profile?.shopName ?? 'Hesabat';
    
    final isRtl = lang == 'fa' || lang == 'ps';
    final calendar = isRtl ? CalendarType.persian : CalendarType.gregorian;

    String _tr(String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);
    String _pd(String val) => isRtl ? _toPersianDigits(val) : val;
    String _nf(num v) => _pd(NumberSystemFormatter.formatFixed(v));

    // Helper for shaping text
    String s(String text) => _shape(text, usePersianDigits: isRtl);

    pw.Widget _buildSummaryRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(s(label), style: pw.TextStyle(fontSize: 12)),
            pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );
    }

    String getProductName(Product p) {
      if (lang == 'fa' && p.nameDari.isNotEmpty) return p.nameDari;
      if (lang == 'ps' && p.namePashto != null && p.namePashto!.isNotEmpty) return p.namePashto!;
      return p.nameEn ?? p.nameDari;
    }

    // Calculations for Summary
    final double totalInventoryValue = products.fold(0, (sum, p) => sum + (p.stockQuantity * p.price));
    final double totalPotentialProfit = products.fold(0, (sum, p) => sum + (p.stockQuantity * (p.price - (p.costPrice ?? 0.0))));
    final double totalSales = sales.fold(0, (sum, s) => sum + s.totalAmount);
    final double totalOwed = customers.fold(0, (sum, c) => sum + c.totalOwed);
    
    final itemsMap = <String, List<SaleItem>>{};
    for (var item in saleItems) {
      itemsMap.putIfAbsent(item.saleId, () => []).add(item);
    }
    final productCosts = {for (var p in products) p.id: p.costPrice ?? 0.0};
    double totalProfit = 0;
    for (var s in sales) {
      for (var item in (itemsMap[s.id] ?? [])) {
        if (item.productId != null) {
          totalProfit += (item.unitPrice - (productCosts[item.productId] ?? 0.0)) * item.quantity;
        }
      }
    }

    // 0. Summary Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(child: pw.Text(s(shopName), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
            pw.Center(child: pw.Text(s(_tr('Business Performance Report', 'گزارش عملکرد کسب‌وکار', 'د سوداګرۍ فعالیت راپور')), style: pw.TextStyle(fontSize: 16, color: PdfColors.grey))),
            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text(s(_tr('Financial Summary', 'خلاصه مالی', 'مالي لنډیز')))),
            _buildSummaryRow(_tr('Total Sales', 'کل فروش', 'ټول پلور'), '${_nf(totalSales)} AFN'),
            _buildSummaryRow(_tr('Total Realized Profit', 'کل سود خالص', 'ټوله خالصه ګټه'), '${_nf(totalProfit)} AFN'),
            _buildSummaryRow(_tr('Total Outstanding Debts', 'کل طلب از مشتریان', 'له پېرودونکو ټول پورونه'), '${_nf(totalOwed)} AFN'),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text(s(_tr('Inventory Summary', 'خلاصه موجودی', 'د موجودي لنډیز')))),
            _buildSummaryRow(_tr('Total Inventory Value (Retail)', 'ارزش موجودی (فروش)', 'د موجودي ارزښت (پلور)'), '${_nf(totalInventoryValue)} AFN'),
            _buildSummaryRow(_tr('Potential Inventory Profit', 'سود احتمالی موجودی', 'د موجودي احتمالي ګټه'), '${_nf(totalPotentialProfit)} AFN'),
            pw.Spacer(),
            pw.Divider(),
            pw.Center(child: pw.Text(s(DateFormatter.formatDateTime(DateTime.now(), calendar: calendar, locale: lang)), style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
          ],
        ),
      ),
    );

    // 1. Inventory Page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        header: (context) => pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(s('Hesabat - ${_tr('Data Export', 'استخراج داده‌ها', 'د معلوماتو استخراج')}'), style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                pw.Text(s(shopName), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(s(_tr('Inventory / Products', 'موجودی / محصولات', 'موجودي / محصولات')))),
          pw.TableHelper.fromTextArray(
            headers: [_tr('Name', 'نام', 'نوم'), _tr('ID/Barcode', 'کد', 'کوډ'), _tr('Stock', 'موجودی', 'موجودي'), _tr('Price', 'قیمت', 'قیمت')].map((e) => s(e)).toList(),
            data: products.map((p) => [
              s(getProductName(p)),
              _pd(p.barcode ?? p.id.substring(0, 8)),
              _nf(p.stockQuantity),
              '${_nf(p.price)} AFN',
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(2),
            },
          ),
        ],
      ),
    );

    // 2. Customers & Debts Page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(s(_tr('Customers & Debts', 'مشتریان و بدهی‌ها', 'پېرودونکي او پورونه')))),
          pw.TableHelper.fromTextArray(
            headers: [_tr('Name', 'نام', 'نوم'), _tr('Phone', 'تلفن', 'تلفن'), _tr('Total Owed', 'کل بدهی', 'ټول پور')].map((e) => s(e)).toList(),
            data: customers.map((c) => [
              s(c.name),
              _pd(c.phone ?? '-'),
              '${_nf(c.totalOwed)} AFN',
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    // 3. Recent Sales Page
    final customerMap = {for (var c in customers) c.id: c.name};

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(s(_tr('Sales History', 'تاریخچه فروش', 'د پلور تاریخچه')))),
          pw.TableHelper.fromTextArray(
            headers: [_tr('Date', 'تاریخ', 'نېټه'), _tr('Customer', 'مشتری', 'پېرودونکی'), _tr('Total', 'مجموع', 'ټول'), _tr('Items', 'کالا', 'توکي')].map((e) => s(e)).toList(),
            data: sales.map((sale) => [
              s(DateFormatter.formatDate(sale.createdAt, calendar: calendar, locale: lang)),
              s(sale.customerId != null ? (customerMap[sale.customerId] ?? sale.customerId!) : '-'),
              '${_nf(sale.totalAmount)} AFN',
              (itemsMap[sale.id] ?? []).map((i) => s('${_pd(i.quantity.toStringAsFixed(0))}x ${i.productNameSnapshot}')).join(', '),
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    // 4. Debt History Page
    final debtHistory = <_LedgerItem>[];
    for (var d in debts) {
      debtHistory.add(_LedgerItem(
        date: d.createdAt,
        customerName: customerMap[d.customerId] ?? d.customerId,
        type: _tr('Debt', 'بدهی', 'پور'),
        amount: d.amountOriginal,
      ));
    }
    for (var dp in debtPayments) {
      final debt = debts.cast<Debt?>().firstWhere((d) => d?.id == dp.debtId, orElse: () => null);
      debtHistory.add(_LedgerItem(
        date: dp.createdAt,
        customerName: customerMap[debt?.customerId] ?? debt?.customerId ?? '-',
        type: _tr('Payment', 'پرداخت', 'تادیه'),
        amount: dp.amount,
      ));
    }
    debtHistory.sort((a, b) => b.date.compareTo(a.date));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(s(_tr('Debt History / Ledger', 'دفتر روزنامه بدهی‌ها', 'د پورونو دفتر')))),
          pw.TableHelper.fromTextArray(
            headers: [_tr('Date', 'تاریخ', 'نېټه'), _tr('Customer', 'مشتری', 'پېرودونکی'), _tr('Type', 'نوع', 'ډول'), _tr('Amount', 'مبلغ', 'مقدار')].map((e) => s(e)).toList(),
            data: debtHistory.map((item) => [
              s(DateFormatter.formatDate(item.date, calendar: calendar, locale: lang)),
              s(item.customerName),
              s(item.type),
              '${_nf(item.amount)} AFN',
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/hesabat_export_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Exported PDF from Hesabat');
  }

  // Reuse RTL shaping logic from ReceiptService
  static String _shape(String text, {bool usePersianDigits = false}) {
    if (text.isEmpty) return text;
    if (!intl.Bidi.hasAnyRtl(text)) return text;

    final List<_TextRun> runs = [];
    final charCodes = text.runes.toList();
    
    String currentRun = "";
    bool currentIsRtl = _isRtl(charCodes[0]);

    for (final charCode in charCodes) {
      final isRtl = _isRtl(charCode);
      if (isRtl == currentIsRtl) {
        currentRun += String.fromCharCode(charCode);
      } else {
        runs.add(_TextRun(currentRun, currentIsRtl));
        currentRun = String.fromCharCode(charCode);
        currentIsRtl = isRtl;
      }
    }
    runs.add(_TextRun(currentRun, currentIsRtl));

    final List<String> processedRuns = [];
    for (final run in runs) {
      if (run.isRtl) {
        var processedText = run.text;
        if (usePersianDigits) {
          processedText = _toPersianDigits(processedText);
        }
        final shaped = ArabicReshaper().reshape(processedText);
        processedRuns.add(shaped.split('').reversed.join(''));
      } else {
        processedRuns.add(run.text);
      }
    }
    return processedRuns.reversed.join('');
  }

  static String _toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }

  static bool _isRtl(int charCode) {
    if (charCode >= 0x06F0 && charCode <= 0x06F9) return false;
    return (charCode >= 0x0600 && charCode <= 0x06FF) ||
           (charCode >= 0x0750 && charCode <= 0x077F) ||
           (charCode >= 0x08A0 && charCode <= 0x08FF) ||
           (charCode >= 0xFB50 && charCode <= 0xFDFF) ||
           (charCode >= 0xFE70 && charCode <= 0xFEFF);
  }
}

class _LedgerItem {
  final DateTime date;
  final String customerName;
  final String type;
  final double amount;

  _LedgerItem({
    required this.date,
    required this.customerName,
    required this.type,
    required this.amount,
  });
}

class _TextRun {
  final String text;
  final bool isRtl;
  _TextRun(this.text, this.isRtl);
}
