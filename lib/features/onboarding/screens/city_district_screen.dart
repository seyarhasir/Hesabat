import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/number_system_formatter.dart';
import '../../../shared/widgets/app_button.dart';

class CityDistrictScreen extends ConsumerStatefulWidget {
  const CityDistrictScreen({super.key});

  @override
  ConsumerState<CityDistrictScreen> createState() => _CityDistrictScreenState();
}

class _CityDistrictScreenState extends ConsumerState<CityDistrictScreen> {
  String _selectedCity = 'Kabul';
  String? _selectedDistrict;

  static const _cities = ['Kabul', 'Herat', 'Mazar-i-Sharif', 'Kandahar', 'Jalalabad'];
  static const _districtsByCity = {
    'Kabul': ['District 1', 'District 2', 'District 3', 'District 4', 'District 5'],
    'Herat': ['District 1', 'District 2', 'District 3'],
    'Mazar-i-Sharif': ['District 1', 'District 2'],
    'Kandahar': ['District 1', 'District 2'],
    'Jalalabad': ['District 1', 'District 2'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stepText = NumberSystemFormatter.apply('2 of 4');

    return Scaffold(
      appBar: AppBar(title: Text(stepText)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('دکان شما کجاست؟', style: theme.textTheme.displaySmall),
              const SizedBox(height: 20),
              Text('شهر', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _selectedCity = v;
                    _selectedDistrict = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('ناحیه', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                hint: const Text('ناحیه را انتخاب کنید'),
                items: (_districtsByCity[_selectedCity] ?? const [])
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDistrict = v),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'بعدی',
                  onPressed: _selectedDistrict == null
                      ? null
                      : () => Navigator.pushNamed(context, '/onboarding/currency'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/onboarding/currency'),
                child: const Text('رد کردن — Skip'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
