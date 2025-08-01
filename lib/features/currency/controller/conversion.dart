import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/provider/dio_provider.dart';
import '../model/currency_model.dart';

final conversionProvider = FutureProvider.family<double, ConversionParams>((ref, params) async {
  // final dio = ref.read(dioProvider);
  // final res = await dio.get('/pair/${params.from}/${params.to}/${params.amount}');
  // return (res.data['conversion_result'] as num).toDouble();

  return 0;
});
