import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/dio_provider.dart';
import '../model/currency_model.dart';

final currencySymbolsProvider = AsyncNotifierProvider<CurrencySymbolsNotifier, List<CurrencySymbol>>(
  CurrencySymbolsNotifier.new,
);

class CurrencySymbolsNotifier extends AsyncNotifier<List<CurrencySymbol>> {
  @override
  Future<List<CurrencySymbol>> build() async {
    // final dio = ref.read(dioProvider);
    // final res = await dio.get('/codes'); // endpoint để lấy danh sách mã
    // final data = res.data['supported_codes'] as List;
    //
    // return data.map((e) {
    //   return CurrencySymbol(code: e[0], name: e[1]); // [code, name]
    // }).toList();
    return [];
  }
}
