import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sync/sync_provider.dart';
import '../../../core/sync/sync_service.dart';

class ConflictResolutionScreen extends ConsumerStatefulWidget {
  const ConflictResolutionScreen({super.key});

  @override
  ConsumerState<ConflictResolutionScreen> createState() => _ConflictResolutionScreenState();
}

class _ConflictResolutionScreenState extends ConsumerState<ConflictResolutionScreen> {
  bool _loading = true;
  List<SyncConflictDetails> _conflicts = const [];

  String get _lang => Localizations.localeOf(context).languageCode;
  String _tr(String en, String fa, [String? ps]) => _lang == 'fa' ? fa : (_lang == 'ps' ? (ps ?? fa) : en);

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final data = await ref.read(syncProvider.notifier).loadConflictDetails();
    if (!mounted) return;
    setState(() {
      _conflicts = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(syncProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Sync Conflicts', 'تعارضات همگام‌سازی', 'د همغږي ټکرونه')),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _conflicts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_tr(
                      'No unresolved conflicts',
                      'تعارض حل\u200cنشده\u200cای وجود ندارد',
                      'نه حل شوي ټکرونه نشته',
                    )),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _conflicts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final conflict = _conflicts[index];
                    final item = conflict.queueItem;
                    final keys = _importantKeys(conflict.localPayload, conflict.serverPayload);

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.targetTable} • ${item.operation}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _typeLabel(conflict.type),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(_tr('Record', 'رکورد', 'ریکارډ') + ': ${item.recordId}'),
                            const SizedBox(height: 4),
                            Text(
                              _typeHint(conflict.type),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if ((item.errorMessage ?? '').isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                item.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            _comparisonHeader(),
                            const SizedBox(height: 6),
                            ...keys.map((k) => _comparisonRow(k, conflict.localPayload[k], conflict.serverPayload?[k])),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _resolve(item.id, ConflictResolutionChoice.useServer),
                                  child: Text(_tr('Use Server', 'نسخه سرور', 'د سرور نسخه')),
                                ),
                                FilledButton.tonal(
                                  onPressed: () => _resolve(item.id, ConflictResolutionChoice.useLocal),
                                  child: Text(_tr('Use Local', 'نسخه محلی', 'ځايي نسخه')),
                                ),
                                FilledButton(
                                  onPressed: () => _resolve(item.id, ConflictResolutionChoice.merge),
                                  child: Text(_tr('Merge', 'ادغام', 'یوځای کول')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _resolve(String queueId, ConflictResolutionChoice choice) async {
    try {
      await ref.read(syncProvider.notifier).resolveConflict(queueId, choice);
      if (!mounted) return;
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Conflict resolved', 'تعارض حل شد', 'ټکر حل شو'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Resolution failed: $e', 'حل ناموفق: $e', 'حل ناکام شو: $e'))),
      );
    }
  }

  String _payloadPreview(String raw) {
    try {
      final parsed = jsonDecode(raw);
      if (parsed is Map<String, dynamic>) {
        final pairs = parsed.entries.take(3).map((e) => '${e.key}: ${e.value}').join(' • ');
        return pairs;
      }
      return raw;
    } catch (_) {
      return raw;
    }
  }

  List<String> _importantKeys(Map<String, dynamic> local, Map<String, dynamic>? server) {
    final set = <String>{
      ...local.keys,
      ...?server?.keys,
    };
    const priority = [
      'id',
      'name',
      'quantity',
      'amount',
      'amount_remaining',
      'sale_price',
      'updated_at',
    ];

    final sorted = set.toList()..sort((a, b) {
      final ia = priority.indexOf(a);
      final ib = priority.indexOf(b);
      if (ia == -1 && ib == -1) return a.compareTo(b);
      if (ia == -1) return 1;
      if (ib == -1) return -1;
      return ia.compareTo(ib);
    });
    return sorted.take(6).toList();
  }

  Widget _comparisonHeader() {
    return Row(
      children: [
        Expanded(child: Text(_tr('Field', 'فیلد', 'ډګر'), style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(_tr('Local', 'محلی', 'ځايي'), style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(_tr('Server', 'سرور', 'سرور'), style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _comparisonRow(String key, dynamic local, dynamic server) {
    String fmt(dynamic v) {
      if (v == null) return '—';
      if (v is Map || v is List) return jsonEncode(v);
      return v.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(key, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(fmt(local), maxLines: 2, overflow: TextOverflow.ellipsis)),
          Expanded(child: Text(fmt(server), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  String _typeLabel(ConflictEntityType type) {
    switch (type) {
      case ConflictEntityType.sales:
        return _tr('Sales', 'فروش', 'پلور');
      case ConflictEntityType.stock:
        return _tr('Stock', 'موجودی', 'ذخیره');
      case ConflictEntityType.debt:
        return _tr('Debt', 'قرض', 'قرض');
      case ConflictEntityType.customer:
        return _tr('Customer', 'مشتری', 'پېرودونکی');
      case ConflictEntityType.productPrice:
        return _tr('Price', 'قیمت', 'بیه');
      case ConflictEntityType.generic:
        return _tr('General', 'عمومی', 'عمومي');
    }
  }

  String _typeHint(ConflictEntityType type) {
    switch (type) {
      case ConflictEntityType.sales:
        return _tr('Sales are append-only. Local record is usually safe.', 'فروش‌ها افزایشی هستند. نسخه محلی معمولاً امن است.', 'پلورونه append-only دي. ځايي نسخه عموماً خوندي ده.');
      case ConflictEntityType.stock:
        return _tr('Stock conflicts can be merged by summing adjustments.', 'تعارض موجودی با جمع تعدیلات قابل ادغام است.', 'د ذخیرې ټکر د تعدیلاتو په جمع حل کېدای شي.');
      case ConflictEntityType.debt:
        return _tr('Debt uses server-authoritative strategy.', 'برای قرض، نسخه سرور معتبر است.', 'د قرض لپاره د سرور نسخه معتبره ده.');
      case ConflictEntityType.customer:
        return _tr('Customer record prefers latest updated value.', 'برای مشتری آخرین بروزرسانی ترجیح دارد.', 'د پېرودونکي لپاره وروستۍ تازه نسخه غوره ده.');
      case ConflictEntityType.productPrice:
        return _tr('Choose local/server price or merge carefully.', 'قیمت محلی/سرور را انتخاب کنید یا با دقت ادغام کنید.', 'ځايي/سرور بیه وټاکئ یا په احتیاط merge کړئ.');
      case ConflictEntityType.generic:
        return _tr('Review both versions before applying.', 'پیش از اعمال هر دو نسخه را بررسی کنید.', 'د پلي کېدو مخکې دواړه نسخې وګورئ.');
    }
  }
}
