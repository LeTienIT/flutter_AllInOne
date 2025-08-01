import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/conversion.dart';
import 'controller/currency_symbols.dart';
import 'controller/vnd_rates.dart';
import 'model/currency_model.dart';

class CurrencyScreen extends ConsumerStatefulWidget{
  const CurrencyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CurrencyScreen();
  }

}

class _CurrencyScreen extends ConsumerState<CurrencyScreen>{
  String fromCurrency = 'USD';
  String toCurrency = 'VND';
  double amount = 1;

  @override
  Widget build(BuildContext context) {
    final symbolState = ref.watch(currencySymbolsProvider);
    final resultState = ref.watch(conversionProvider(ConversionParams(
      from: fromCurrency,
      to: toCurrency,
      amount: amount,
    )));
    final rateState = ref.watch(vndRatesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Chuyển đổi tỷ giá'),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            symbolState.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => throw Exception('Lỗi: $e'),
              data: (symbols) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        items: symbols
                            .map((e) => DropdownMenuItem(
                          value: e.code,
                          child: Text(e.code),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              print("before: $fromCurrency");
                              fromCurrency = val;
                              print("late: $fromCurrency");
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: toCurrency,
                        isExpanded: true,
                        items: symbols
                            .map((e) => DropdownMenuItem(
                          value: e.code,
                          child: Text(e.code),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => toCurrency = val);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Nhập số tiền'),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final numVal = double.tryParse(val);
                if (numVal != null) {
                  setState(() {
                    print(amount);
                    amount = numVal;
                    print(amount);
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            resultState.when(
              loading: () => Text('Đang chuyển đổi...'),
              error: (e, _) => Text('Lỗi chuyển đổi: $e'),
              data: (result) => Text(
                '$amount $fromCurrency = ${result.toStringAsFixed(2)} $toCurrency',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
                onPressed: (){

                },
                child: Text('Chuyển đổi')
            ),
            SizedBox(height: 16,),
            Divider(height: 1,),
            rateState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Lỗi khi tải tỷ giá: $e'),
              data: (rates) {
                final sortedRates = rates.entries.toList()
                  ..sort((a, b) => a.key.compareTo(b.key));

                return Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  children: sortedRates.map((entry) {
                    final code = entry.key;
                    final rate = entry.value;
                    if (rate == 0) return const SizedBox.shrink();

                    return Chip(
                      label: Text(
                        '1 $code = ${(1 / rate).toStringAsFixed(0)} VND',
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.blue.shade50,
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }

}