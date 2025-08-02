import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/dio_provider.dart';
import '../model/currency_model.dart';

final currencySymbolsProvider = AsyncNotifierProvider<CurrencySymbolsNotifier, List<CurrencySymbol>>(
  CurrencySymbolsNotifier.new,
);

class CurrencySymbolsNotifier extends AsyncNotifier<List<CurrencySymbol>> {
  @override
  Future<List<CurrencySymbol>> build() async {
    final dio = ref.read(dioProvider);
    final res = await dio.get('currencies');

    final data = res.data as Map<String, dynamic>;

    return data.entries.map((entry) {
      return CurrencySymbol(code: entry.key, name: entry.value as String);
    }).toList();
  }

}
