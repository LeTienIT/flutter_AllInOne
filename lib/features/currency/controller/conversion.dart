import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/provider/dio_provider.dart';

final currencyConvertProvider = AsyncNotifierProvider<CurrencyConvertNotifier, double>(
  CurrencyConvertNotifier.new,
);

class CurrencyConvertNotifier extends AsyncNotifier<double> {
  @override
  Future<double> build() async {
    return 0.0;
  }

  Future<void> convert({required double amount, required String fromCurrency, required String toCurrency,}) async {
    state = const AsyncLoading();

    final dio = ref.read(dioProvider);
    final url = 'latest?amount=$amount&from=$fromCurrency&to=$toCurrency';

    try {
      final res = await dio.get(url);
      final rate = (res.data['rates'][toCurrency] as num).toDouble();

      state = AsyncData(rate);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
