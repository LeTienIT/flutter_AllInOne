import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/dio_provider.dart';

final vndRatesProvider = AsyncNotifierProvider<VNDRatesNotifier, Map<String, double>>(
  VNDRatesNotifier.new,
);

class VNDRatesNotifier extends AsyncNotifier<Map<String, double>> {
  @override
  Future<Map<String, double>> build() async {
    // final dio = ref.read(dioProvider);
    // final res = await dio.get('/latest/VND');
    // final data = res.data['conversion_rates'] as Map<String, dynamic>;
    // return data.map((key, value) => MapEntry(key, (value as num).toDouble()));

    return {};
  }
}
