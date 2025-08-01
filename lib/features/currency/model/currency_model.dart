class CurrencySymbol {
  final String code;     // e.g. USD
  final String name;     // e.g. United States Dollar

  CurrencySymbol({required this.code, required this.name});
}

class ConversionParams {
  final String from;
  final String to;
  final double amount;

  ConversionParams({required this.from, required this.to, required this.amount});
}
