import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/utils/barcode_lookup_service.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isHandling = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(String code) async {
    if (_isHandling) return;
    _isHandling = true;

    final db = ref.read(databaseProvider);
    final shopId = ref.read(currentShopIdProvider);
    final outcome = await BarcodeLookupService.instance.lookup(
      db: db,
      shopId: shopId,
      barcode: code,
    );

    if (!mounted) return;

    if (outcome.localProduct != null) {
      final product = outcome.localProduct!;
      HapticFeedback.mediumImpact();
      Navigator.pop(context, {
        'productId': product.id,
        'barcode': code,
      });
      return;
    }

    final candidate = outcome.candidate;
    if (candidate != null) {
      final confirmed = await _showLookupConfirmSheet(candidate);
      if (!mounted) return;

      if (confirmed == true) {
        final product = await BarcodeLookupService.instance.saveCandidateLocally(
          db: db,
          shopId: shopId,
          candidate: candidate,
        );

        await BarcodeLookupService.instance.saveCandidateToCommunity(candidate);

        if (!mounted) return;
        HapticFeedback.mediumImpact();
        Navigator.pop(context, {
          'productId': product.id,
          'barcode': code,
        });
        return;
      }
    }

    await _showManualEntryPrompt(code, isOffline: !ConnectivityService.instance.isOnline);
    _isHandling = false;
  }

  Future<void> _showManualEntryPrompt(String code, {required bool isOffline}) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isOffline ? 'آفلاین: محصول فقط دستی اضافه می‌شود' : 'محصول یافت نشد — اضافه کنید؟',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('Barcode: $code'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(this.context, {
                      'barcode': code,
                      'notFound': true,
                    });
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('افزودن محصول جدید'),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('بستن'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showLookupConfirmSheet(BarcodeLookupCandidate candidate) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        Widget row(String label, String value) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 96, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
                Expanded(child: Text(value.isEmpty ? '-' : value)),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('محصول پیدا شد — تایید می‌کنید؟', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  row('Barcode', candidate.barcode),
                  row('Name (EN)', candidate.nameEn),
                  row('Name (Dari)', candidate.nameDari),
                  row('Brand', candidate.manufacturer ?? '-'),
                  row('Unit', candidate.unit),
                  row('Category', candidate.categoriesTags.isEmpty ? '-' : candidate.categoriesTags.first),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('تایید و افزودن'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                      Navigator.pop(this.context, {
                        'barcode': candidate.barcode,
                        'notFound': true,
                      });
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('ورود دستی'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openManualEntry() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('وارد کردن دستی بارکد'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Barcode'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('لغو')),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('تایید'),
            ),
          ],
        );
      },
    );

    if (value != null && value.isNotEmpty) {
      await _handleBarcode(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('اسکن بارکد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
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
                    
                    final String? raw = barcodes.first.rawValue;
                    if (raw == null || raw.isEmpty) return;
                    
                    await _handleBarcode(raw.trim());
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('بارکد را در مقابل دوربین نگه دارید'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                await _controller.toggleTorch();
                setState(() => _torchOn = !_torchOn);
              },
              icon: Icon(_torchOn ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded),
              label: Text(_torchOn ? 'خاموش کردن چراغ' : 'روشن کردن چراغ'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _openManualEntry,
              child: const Text('وارد کردن دستی'),
            ),
          ],
        ),
      ),
    );
  }
}
