enum FunctionType {
  linear, // ax + b
  quadratic, // ax^2 + bx + c
  exponential, // e^x
  logarithmic, // log(x)
  sine,
  cosine,
  tangent,
}
String functionTypeName(FunctionType e){
  switch(e){
    case FunctionType.linear:
      return 'Ax + B';
    case FunctionType.quadratic:
      return 'Ax^2 + Bx + C';
    case FunctionType.exponential:
      return 'e^x';
    case FunctionType.logarithmic:
      return 'log(x)';
    case FunctionType.sine:
      return 'sin(x)';
    case FunctionType.cosine:
      return 'cos(x)';
    case FunctionType.tangent:
      return 'tan(x)';
    default:
      return e.name;
  }
}
class FunctionConfig {
  final FunctionType type;
  final double? a;
  final double? b;
  final double? c;

  FunctionConfig({
    required this.type,
    this.a,
    this.b,
    this.c,
  });
}
