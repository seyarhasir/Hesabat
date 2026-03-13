import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class ShopSetupScreen extends ConsumerStatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  ConsumerState<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends ConsumerState<ShopSetupScreen> {
  final _shopNameController = TextEditingController();
  String? _selectedShopType;
  String? _selectedCity;
  String? _selectedDistrict;

  final _shopTypes = const [
    {'code': 'grocery', 'name': 'Grocery', 'icon': '\u{1F6D2}'},
    {'code': 'pharmacy', 'name': 'Pharmacy', 'icon': '\u{1F48A}'},
    {'code': 'hardware', 'name': 'Hardware', 'icon': '\u{1F527}'},
    {'code': 'electronics', 'name': 'Electronics', 'icon': '\u{1F4F1}'},
    {'code': 'clothing', 'name': 'Clothing', 'icon': '\u{1F457}'},
    {'code': 'bakery', 'name': 'Bakery', 'icon': '\u{1F35E}'},
    {'code': 'restaurant', 'name': 'Restaurant', 'icon': '\u{1F37D}'},
    {'code': 'general', 'name': 'General', 'icon': '\u{1F3EA}'},
  ];

  final _cities = const ['Kabul', 'Herat', 'Mazar-i-Sharif', 'Kandahar', 'Jalalabad', 'Other'];
  final _kabulDistricts = const ['Karte Char', 'Wazir Akbar Khan', 'Kote Sangi', 'Taimani', 'Shahr-e-Naw', 'Deh Afghanan', 'Other'];

  bool get _isValid =>
      _shopNameController.text.isNotEmpty &&
      _selectedShopType != null &&
      _selectedCity != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stepText = NumberSystemFormatter.apply('Step 2 of 4');

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
                child: LinearProgressIndicator(value: 0.5, minHeight: 4),
              ),
              const SizedBox(height: 8),
              Text(stepText, style: theme.textTheme.bodySmall),

              const SizedBox(height: 24),

              Text('Set Up Your Shop', style: theme.textTheme.displaySmall),
              const SizedBox(height: 4),
              Text('Enter your shop details', style: theme.textTheme.bodyMedium),

              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shop Name', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: _shopNameController,
                        hint: 'e.g., Ahmad Grocery Store',
                        isRTL: false,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 24),

                      Text('Shop Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _shopTypes.map((type) {
                          final isSelected = _selectedShopType == type['code'];
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(type['icon']!),
                                const SizedBox(width: 4),
                                Text(type['name']!),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (v) => setState(() => _selectedShopType = v ? type['code'] : null),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      Text('City', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        hint: const Text('Select city'),
                        items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() { _selectedCity = v; _selectedDistrict = null; }),
                      ),

                      if (_selectedCity == 'Kabul') ...[
                        const SizedBox(height: 16),
                        Text('District', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedDistrict,
                          hint: const Text('Select district'),
                          items: _kabulDistricts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                          onChanged: (v) => setState(() => _selectedDistrict = v),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: _isValid ? () => Navigator.pushNamed(context, '/onboarding/city-district') : null,
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
