import 'dart:math' as math;
import '../model/function_config.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphController{
  late FunctionConfig config;
  late double minX, maxX;

  GraphController(this.config, {this.minX = -10, this.maxX = 10});

  List<FlSpot> generateGraphPoints() {
    const step = 0.1;
    final points = <FlSpot>[];

    for (double x = minX; x <= maxX; x += step) {
      final y = evaluateFx(x);
      if (y.isFinite) {
        points.add(FlSpot(x, y));
      }
    }

    return points;
  }

  double evaluateFx(double x) {
    switch (config.type) {
      case FunctionType.linear:      // f(x) = Ax + B
        return config.a! * x + config.b!;

      case FunctionType.quadratic:   // f(x) = Ax² + Bx + C
        return config.a! * x * x + config.b! * x + config.c!;

      case FunctionType.exponential: // f(x) = e^x
        return math.exp(x);

      case FunctionType.logarithmic: // f(x) = log(x)
        return x > 0 ? math.log(x) : double.nan;

      case FunctionType.sine:
        return math.sin(x);

      case FunctionType.cosine:
        return math.cos(x);

      case FunctionType.tangent:
        final tan = math.tan(x);
        return tan.abs() < 1e4 ? tan : double.nan;
    }
  }

  String solveEquation() {
    switch (config.type) {
      case FunctionType.linear:
        final a = config.a ?? 0;
        final b = config.b ?? 0;
        if (a == 0 && b == 0) {
          return '''
PT: 0x + 0 = 0
________________________________
Cách giải:
  - Phương trình vô số nghiệm (đúng với mọi x).
________________________________
Nghiệm: ∞ (vô số)
           ''';
        }
        else if (a == 0 && b != 0) {
          return '''
Phương trình: 0x + ($b) = 0
________________________________
Cách giải:
  - Phương trình vô nghiệm vì 0x không thể bằng ${-b}.
________________________________
Nghiệm: Không có nghiệm.
            ''';
        }
        else {
          final x = -b / a;
          return '''
PT: ${a}x + ($b) = 0
________________________________
Cách giải:
  ⇒ ${a}x = ${-b}
  ⇒ x = ${-b} / ($a)
  ⇒ x = ${x.toStringAsFixed(2)}
________________________________
Nghiệm: (Giá trị đã được làm tròn)
  ⇒ x = ${x.toStringAsFixed(2)}
          ''';
        }

      case FunctionType.quadratic:
        final a = config.a ?? 0;
        final b = config.b ?? 0;
        final c = config.c ?? 0;

        if (a == 0) {
          final x = b == 0
              ? (c == 0 ? double.infinity : double.nan)
              : -c / b;
          if (b == 0 && c == 0) {
            return '''
PT: 0x + 0 = 0
________________________________
Cách giải:
  - Vô số nghiệm.
________________________________
Nghiệm: ∞ (vô số)
            ''';
          }
          else if (b == 0) {
            return '''
PT: 0x + ($c) = 0
________________________________
Cách giải: Vô nghiệm.
________________________________
Nghiệm: Không có nghiệm.
              ''';
          }
          else {
            return '''
PT: ${b}x + ($c) = 0
________________________________
Cách giải:
  ⇒ x = - ($c) / ($b)
  ⇒ x = ${x.toStringAsFixed(2)}
________________________________
Nghiệm: (Giá trị đã được làm tròn)
  ⇒ x = ${x.toStringAsFixed(2)}
            ''';
          }
        }

        final delta = b * b - 4 * a * c;
        final deltaStr = '$b² - 4 × ($a) × ($c)';
        final deltaStr2 = '(${b * b}) - (${4 * a * c})';
        final deltaStr3 = '$delta';

        if (delta < 0) {
          return '''
PT: ${a}x² + (${b}x) + ($c) = 0
________________________________
Cách giải:
  ⇒ Δ = B² - 4 × A × C
  ⇒ Δ = $deltaStr
  ⇒ Δ = $deltaStr2
  ⇒ Δ = $deltaStr3
  ⇒ Vì Δ < 0 nên phương trình vô nghiệm.
________________________________
Nghiệm: Không có nghiệm thực.
            ''';
        }
        else if (delta == 0) {
          final x = -b / (2 * a);
          return '''
PT: ${a}x² + (${b}x) + ($c) = 0
________________________________
Cách giải:
  ⇒ Δ = B² - 4 × A × C
  ⇒ Δ = $deltaStr
  ⇒ Δ = $deltaStr2
  ⇒ Δ = $deltaStr3
  ⇒ Vì Δ = 0 ⇒ phương trình có nghiệm kép
________________________________
Nghiệm: (Giá trị đã được làm tròn)
  ⇒ x = ${x.toStringAsFixed(2)}
          ''';
        }
        else {
          final sqrtDelta = math.sqrt(delta);
          final x1 = (-b + sqrtDelta) / (2 * a);
          final x2 = (-b - sqrtDelta) / (2 * a);
          return '''
PT: ${a}x² + (${b}x) + ($c) = 0
________________________________
Cách giải:
  ⇒ Δ = B² - 4 × A × C
  ⇒ Δ = $deltaStr
  ⇒ Δ = $deltaStr2
  ⇒ Δ = $deltaStr3
  ⇒ Vì Δ > 0 nên phương trình có 2 nghiệm phân biệt
________________________________
Nghiệm: (Giá trị đã được làm tròn)
  ⇒ x₁ = ${x1.toStringAsFixed(2)}
  ⇒ x₂ = ${x2.toStringAsFixed(2)}
           ''';
        }
        default:
          return '''
Phương trình dạng đặc biệt (${config.type.name}) không hỗ trợ giải nghiệm.
          ''';
    }
  }

}