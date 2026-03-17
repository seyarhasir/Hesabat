import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:intl/intl.dart' as intl;
import '../settings/shop_profile_service.dart';
import 'date_formatter.dart';
import 'number_system_formatter.dart';

class ReceiptService {
  static Future<void> shareReceipt({
    required List<Map<String, dynamic>> items,
    required double total,
    required String currency,
    required String paymentMethod,
    String? customerName,
    required String lang,
  }) async {
    final file = await generateReceiptPdf(
      items: items,
      total: total,
      currency: currency,
      paymentMethod: paymentMethod,
      customerName: customerName,
      lang: lang,
    );

    await Share.shareXFiles([XFile(file.path)], text: 'Receipt from Hesabat');
  }

  static Future<File> generateReceiptPdf({
    required List<Map<String, dynamic>> items,
    required double total,
    required String currency,
    required String paymentMethod,
    String? customerName,
    required String lang,
  }) async {
    final pdf = pw.Document();
    final profile = await ShopProfileService.loadWithCloudFallback();
    final shopName = profile?.shopName ?? 'Hesabat';
    final city = profile?.city ?? '';
    final district = profile?.district ?? '';
    final shopAddress = city.isNotEmpty ? "$city${district.isNotEmpty ? ', $district' : ''}" : '';
    final shopPhone = ''; // Phone field not present in ShopProfile model yet

    // Load font for RTL support
    final fontData = await rootBundle.load("assets/fonts/Vazirmatn-Regular.ttf");
    final font = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load("assets/fonts/Vazirmatn-Bold.ttf");
    final boldFont = pw.Font.ttf(boldFontData);

    String _tr(String en, String fa, [String? ps]) => lang == 'fa' ? fa : (lang == 'ps' ? (ps ?? fa) : en);
    String _pd(String val) => (lang == 'fa' || lang == 'ps') ? _toPersianDigits(val) : val;
    String _nf(num v) => _pd(NumberSystemFormatter.formatFixed(v));

    String currencySymbol(String code) {
      switch (code) {
        case 'USD': return r'$';
        case 'PKR': return 'Rs';
        default: return 'AFN';
      }
    }

    // Use Persian calendar for fa/ps
    final calendar = (lang == 'fa' || lang == 'ps') ? CalendarType.persian : CalendarType.gregorian;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header (KABOBISTAN Style)
              pw.Text(_shape(shopName.toUpperCase()), style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              if (shopAddress.isNotEmpty) pw.Text(_shape(shopAddress), style: const pw.TextStyle(fontSize: 9)),
              if (shopPhone.isNotEmpty) pw.Text(_shape(shopPhone), style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),

              // Order Info
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _infoRow(_tr('Receipt #', 'شماره رسید', 'د رسید شمیره'), '#${_pd(DateTime.now().millisecondsSinceEpoch.toString().substring(7))}', font, usePersianDigits: (lang == 'fa' || lang == 'ps'), isRtl: (lang == 'fa' || lang == 'ps')),
                    _infoRow(_tr('Date:', 'تاریخ:', 'نېټه:'), _pd(DateFormatter.formatDateTime(DateTime.now(), calendar: calendar, locale: lang)), font, usePersianDigits: (lang == 'fa' || lang == 'ps'), isRtl: (lang == 'fa' || lang == 'ps')),
                    if (customerName != null) _infoRow(_tr('Customer:', 'مشتری:', 'پېرودونکی:'), customerName, font, usePersianDigits: (lang == 'fa' || lang == 'ps'), isRtl: (lang == 'fa' || lang == 'ps')),
                    _infoRow(_tr('Payment:', 'پرداخت:', 'تادیه:'), paymentMethod.toUpperCase(), font, usePersianDigits: (lang == 'fa' || lang == 'ps'), isRtl: (lang == 'fa' || lang == 'ps')),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),

              // Items Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: (lang == 'fa' || lang == 'ps') 
                  ? [
                      pw.Text(_shape(_tr('Subtotal', 'مجموع', 'ټول')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      pw.Text(_shape(_tr('Item', 'کالا', 'توکي')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ]
                  : [
                      pw.Text(_shape(_tr('Item', 'کالا', 'توکي')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                      pw.Text(_shape(_tr('Subtotal', 'مجموع', 'ټول')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ],
              ),
              pw.SizedBox(height: 3),

              // Items List
              ...items.map((item) {
                final qty = (item['quantity'] as num?)?.toDouble() ?? 0;
                final price = (item['price'] as num?)?.toDouble() ?? 0;
                final sub = qty * price;
                final itemName = (item['name'] as String?) ?? '';
                final itemRow = [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: (lang == 'fa' || lang == 'ps') ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(_shape('${_nf(qty)}x $itemName', usePersianDigits: (lang == 'fa' || lang == 'ps')), style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(_shape('${_nf(sub)} ${currencySymbol(currency)}', usePersianDigits: (lang == 'fa' || lang == 'ps')), style: const pw.TextStyle(fontSize: 9)),
                ];
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: (lang == 'fa' || lang == 'ps') ? itemRow.reversed.toList() : itemRow,
                  ),
                );
              }),

              pw.SizedBox(height: 5),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 5),

              // Totals Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: (lang == 'fa' || lang == 'ps')
                  ? [
                      pw.Text(_shape('${_nf(total)} ${currencySymbol(currency)}', usePersianDigits: (lang == 'fa' || lang == 'ps')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(_shape(_tr('TOTAL PAID', 'جمع کل پرداختی', 'ټولیزه تادیه'), usePersianDigits: (lang == 'fa' || lang == 'ps')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    ]
                  : [
                      pw.Text(_shape(_tr('TOTAL PAID', 'جمع کل پرداختی', 'ټولیزه تادیه'), usePersianDigits: (lang == 'fa' || lang == 'ps')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(_shape('${_nf(total)} ${currencySymbol(currency)}', usePersianDigits: (lang == 'fa' || lang == 'ps')), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                    ],
              ),

              pw.SizedBox(height: 20),
              pw.Text('*** ${_shape(_tr('CUSTOMER COPY', 'نسخه مشتری', 'د پېرودونکي کاپي'))} ***', style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 5),
              pw.Text(_shape(_tr('Thank you for choosing $shopName', 'از انتخاب $shopName متشکریم', 'د $shopName له غوره کولو مننه')), style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 5),
              pw.Text('Powered by Hesabat', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static String _shape(String text, {bool usePersianDigits = false}) {
    if (text.isEmpty) return text;
    
    // Check if contains RTL characters. If not, just return text as is.
    if (!intl.Bidi.hasAnyRtl(text)) return text;

    // Tokenize string into LTR and RTL blocks to preserve English words/numbers
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

    // Process runs: 
    // - RTL runs are reshaped (joined) and reversed.
    // - LTR runs are kept as is.
    // Then reverse the order of ALL runs for BiDi reordering.
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

    // BiDi Reordering: First logical block goes to the end of physical line in LTR engine
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
    // Basic check for Arabic/Persian range, but EXCLUDE digits (0x06F0-0x06F9)
    if (charCode >= 0x06F0 && charCode <= 0x06F9) return false;

    return (charCode >= 0x0600 && charCode <= 0x06FF) ||
           (charCode >= 0x0750 && charCode <= 0x077F) ||
           (charCode >= 0x08A0 && charCode <= 0x08FF) ||
           (charCode >= 0xFB50 && charCode <= 0xFDFF) ||
           (charCode >= 0xFE70 && charCode <= 0xFEFF);
  }

  static pw.Widget _infoRow(String label, String value, pw.Font font, {bool usePersianDigits = false, bool isRtl = false}) {
    final children = [
      pw.Text(_shape(label, usePersianDigits: usePersianDigits), style: const pw.TextStyle(fontSize: 9)),
      pw.Text(_shape(value, usePersianDigits: usePersianDigits), style: pw.TextStyle(fontSize: 9, font: font)),
    ];
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: isRtl ? children.reversed.toList() : children,
      ),
    );
  }
}

class _TextRun {
  final String text;
  final bool isRtl;
  _TextRun(this.text, this.isRtl);
}
