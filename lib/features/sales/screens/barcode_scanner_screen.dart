import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/database/database_provider.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    autoZoom: true,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.itf,
    ],
  );
  final TextEditingController _manualBarcodeController = TextEditingController();
  bool _isHandling = false;
  bool _torchOn = false;
  String _lastDetected = '';

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  @override
  void dispose() {
    _manualBarcodeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _normalizeBarcode(String value) => value.replaceAll(RegExp(r'[^0-9]'), '').trim();

  Future<void> _handleBarcode(String code) async {
    if (_isHandling) return;
    final normalizedCode = _normalizeBarcode(code);
    if (normalizedCode.length < 8) return;
    _isHandling = true;

    try {
      final db = ref.read(databaseProvider);
      final shopId = ref.read(currentShopIdProvider);
      final local = await db.productsDao.getProductByBarcode(shopId, normalizedCode);

      if (!mounted) return;

      if (local != null) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context, {
          'productId': local.id,
          'barcode': normalizedCode,
        });
        return;
      }

      // New barcode: immediately open add-product details flow in sales screen.
      HapticFeedback.lightImpact();
      Navigator.pop(context, {
        'barcode': normalizedCode,
        'notFound': true,
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_tr('Scan failed, try again', 'اسکن انجام نشد، دوباره تلاش کنید', 'سکن ناکام شو، بیا هڅه وکړئ'))),
        );
      }
      _isHandling = false;
    }
  }

  Future<void> _submitManualBarcode() async {
    final value = _normalizeBarcode(_manualBarcodeController.text);
    if (value.isEmpty) return;
    await _handleBarcode(value);
    _manualBarcodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_tr('Scan barcode', 'اسکن بارکد', 'بارکوډ سکین')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                clipBehavior: Clip.antiAlias,
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (BarcodeCapture capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isEmpty) return;

                    final normalizedCandidates = barcodes
                        .map((b) => b.rawValue ?? b.displayValue ?? '')
                        .map(_normalizeBarcode)
                        .where((code) => code.isNotEmpty)
                        .toList();
                    if (normalizedCandidates.isEmpty) return;

                    normalizedCandidates.sort((a, b) => b.length.compareTo(a.length));
                    if (mounted) {
                      setState(() => _lastDetected = normalizedCandidates.first);
                    }
                    await _handleBarcode(normalizedCandidates.first);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(_tr('Hold barcode inside the frame', 'بارکد را در مقابل دوربین نگه دارید', 'بارکوډ د چوکاټ دننه ونیسئ')),
            if (_lastDetected.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _tr('Detected: $_lastDetected', 'تشخیص داده‌شده: $_lastDetected', 'تشخیص شوی: $_lastDetected'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65)),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                await _controller.toggleTorch();
                setState(() => _torchOn = !_torchOn);
              },
              icon: Icon(_torchOn ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded),
              label: Text(_torchOn
                  ? _tr('Turn torch off', 'خاموش کردن چراغ', 'چراغ بند کړئ')
                  : _tr('Turn torch on', 'روشن کردن چراغ', 'چراغ بل کړئ')),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _manualBarcodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Manual barcode', 'بارکد دستی', 'لاسي بارکوډ'),
                hintText: _tr('Enter barcode number', 'شماره بارکد را وارد کنید', 'د بارکوډ شمېره دننه کړئ'),
                prefixIcon: const Icon(Icons.edit_rounded),
              ),
              onSubmitted: (_) => _submitManualBarcode(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _submitManualBarcode,
                icon: const Icon(Icons.search_rounded),
                label: Text(_tr('Find / Add product', 'یافتن / افزودن محصول', 'محصول ومومئ / زیات کړئ')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
