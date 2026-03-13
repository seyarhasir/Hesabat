import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../core/settings/app_locale_provider.dart';
import '../../../shared/widgets/app_button.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String? _selectedLanguage;

  final _languages = const [
    {'code': 'fa', 'name': '\u0641\u0627\u0631\u0633\u06CC (\u062F\u0631\u06CC)', 'nameEn': 'Dari', 'flag': '\u{1F1E6}\u{1F1EB}'},
    {'code': 'ps', 'name': '\u067E\u069A\u062A\u0648', 'nameEn': 'Pashto', 'flag': '\u{1F1E6}\u{1F1EB}'},
    {'code': 'en', 'name': 'English', 'nameEn': 'English', 'flag': '\u{1F1EC}\u{1F1E7}'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(appSettingsLocaleProvider).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final stepText = NumberSystemFormatter.apply('Step 1 of 4');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: 0.25, minHeight: 4),
              ),
              const SizedBox(height: 8),
              Text(stepText, style: theme.textTheme.bodySmall),

              const SizedBox(height: 32),

              Text('Select Language', style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text(
                '\u0632\u0628\u0627\u0646 \u062E\u0648\u062F \u0631\u0627 \u0627\u0646\u062A\u062E\u0627\u0628 \u06A9\u0646\u06CC\u062F',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Language list
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final lang = _languages[i];
                    final isSelected = _selectedLanguage == lang['code'];

                    return GestureDetector(
                      onTap: () {
                        final code = lang['code']!;
                        setState(() => _selectedLanguage = code);
                        ref.read(appSettingsLocaleProvider.notifier).setLocale(Locale(code));
                      },
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
                            Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['name']!,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(lang['nameEn']!, style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded, color: cs.primary, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // RTL hint
              if (_selectedLanguage == 'fa' || _selectedLanguage == 'ps')
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.secondary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded, color: cs.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Layout will switch to right-to-left (RTL)',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: _selectedLanguage == null
                      ? null
                      : () {
                          ref.read(appSettingsLocaleProvider.notifier).setLocale(Locale(_selectedLanguage!));
                          Navigator.pushNamed(context, '/auth/phone');
                        },
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
