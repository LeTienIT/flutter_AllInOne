import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/conversion.dart';
import 'controller/currency_symbols.dart';

class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key});

  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreen();
}

class _CurrencyScreen extends ConsumerState<CurrencyScreen> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  final TextEditingController input = TextEditingController();
  final TextEditingController output = TextEditingController(text: 'Chuyển đổi ...');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    input.dispose();
    output.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final symbolState = ref.watch(currencySymbolsProvider);
    final convertState = ref.watch(currencyConvertProvider);
    ref.listen<AsyncValue<double>>(
      currencyConvertProvider,
          (previous, next) {
        next.when(
          data: (value) {
            output.text = value.toStringAsFixed(2);
          },
          loading: () {
            output.text = "Đang chuyển đổi...";
          },
          error: (err, _) {
            output.text = "Lỗi chuyển đổi: $err";
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Chuyển đổi tỷ giá'),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            symbolState.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => throw Exception('Lỗi: $e'),
              data: (symbols) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownSearch<String>(
                        selectedItem: fromCurrency,
                        items: symbols.map((e) => e.code).toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Từ tiền tệ",
                            hintText: "Chọn loại tiền...",
                          ),
                        ),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm mã tiền...",
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              fromCurrency = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownSearch<String>(
                        selectedItem: toCurrency,
                        items: symbols.map((e) => e.code).toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Sang tiền tệ",
                            hintText: "Chọn loại tiền...",
                          ),
                        ),
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm mã tiền...",
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => toCurrency = val);
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: input,
              decoration: const InputDecoration(labelText: 'Nhập số tiền'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: output,
              decoration: const InputDecoration(labelText: 'Kết quả'),
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            ElevatedButton(
                onPressed: convertState.isLoading ? null : () {
                  final inputAmount = input.text;
                  if(inputAmount.isEmpty){
                    output.text = 'Không hợp lệ';
                    return;
                  }
                  ref.read(currencyConvertProvider.notifier).convert(
                    amount: double.parse(inputAmount),
                    fromCurrency: fromCurrency,
                    toCurrency: toCurrency,
                  );
                },
              child: convertState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Chuyển đổi'),
            ),
            SizedBox(height: 16,),
            Divider(height: 1,),
            SizedBox(height: 8,),
            Text('Danh sách loại tiền hỗ trợ',style: Theme.of(context).textTheme.titleMedium,),
            symbolState.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => throw Exception('Lỗi: $e'),
              data: (symbols) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Wrap(
                    spacing: 3,
                    children: [
                      ...symbols.map((e){
                        return Chip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e.code,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                e.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }

}