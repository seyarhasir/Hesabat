import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/app_button.dart';

class CurrencyPreferenceScreen extends ConsumerStatefulWidget {
  const CurrencyPreferenceScreen({super.key});

  @override
  ConsumerState<CurrencyPreferenceScreen> createState() => _CurrencyPreferenceScreenState();
}

class _CurrencyPreferenceScreenState extends ConsumerState<CurrencyPreferenceScreen> {
  String _primaryCurrency = 'AFN';
  String? _secondaryCurrency;

  final _currencies = const [
    {'code': 'AFN', 'name': 'Afghan Afghani', 'symbol': '\u060B', 'flag': '\u{1F1E6}\u{1F1EB}'},
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$', 'flag': '\u{1F1FA}\u{1F1F8}'},
    {'code': 'PKR', 'name': 'Pakistani Rupee', 'symbol': '\u20A8', 'flag': '\u{1F1F5}\u{1F1F0}'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final stepText = NumberSystemFormatter.apply('Step 3 of 4');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: 0.75, minHeight: 4),
              ),
              const SizedBox(height: 8),
              Text(stepText, style: theme.textTheme.bodySmall),

              const SizedBox(height: 24),

              Text('Currency', style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text('Select your primary currency', style: theme.textTheme.bodyMedium),

              const SizedBox(height: 24),

              Text('Primary Currency', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              ..._currencies.map((c) {
                final isSelected = _primaryCurrency == c['code'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _primaryCurrency = c['code']!;
                      if (_secondaryCurrency == c['code']) _secondaryCurrency = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? cs.secondary.withOpacity(0.05) : cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? cs.primary : cs.outline,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(c['flag']!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['name']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text('${c['symbol']} ${c['code']}', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: cs.primary, size: 24),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              Text('Secondary (Optional)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _secondaryCurrency,
                hint: const Text('None'),
                items: _currencies
                    .where((c) => c['code'] != _primaryCurrency)
                    .map((c) => DropdownMenuItem(
                          value: c['code'],
                          child: Row(
                            children: [
                              Text(c['flag']!),
                              const SizedBox(width: 8),
                              Text('${c['name']} (${c['symbol']})'),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _secondaryCurrency = v),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.secondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outline),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sync_rounded, color: cs.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Rates update daily. Reports default to AFN.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: () => Navigator.pushNamed(context, '/onboarding/first-product'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
