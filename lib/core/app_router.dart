import 'package:all_in_one_tool/features/calculator/calculator_screen.dart';
import 'package:all_in_one_tool/features/calculator/expression_screen.dart';
import 'package:all_in_one_tool/features/calculator/math_graph_screen.dart';
import 'package:all_in_one_tool/features/calendar/calendar_more_screen.dart';
import 'package:all_in_one_tool/features/calendar/calendar_screen.dart';
import 'package:all_in_one_tool/features/image/image_screen.dart';
import 'package:all_in_one_tool/features/time/time_screen.dart';
import 'package:all_in_one_tool/features/unit/unit_screen.dart';
import 'package:all_in_one_tool/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../features/currency/currency_screen.dart';

class AppRouter{
  static const String home = '/';
  static const currency = '/currency';
  static const unit = '/unit';
  static const time = '/time';
  static const calendar = '/calendar';
  static const calendarMore = '/calendar-more';
  static const calculator = '/calculator';
  static const calculatorExp = '/calculator-expression';
  static const graph = '/graph';
  static const resize = '/resize';

  static MaterialPageRoute onGenerateRouter(RouteSettings setting){
    switch(setting.name){
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case currency:
        return MaterialPageRoute(builder: (_) => const CurrencyScreen());
      case unit:
        return MaterialPageRoute(builder: (_) => const UnitScreen());
      case time:
        return MaterialPageRoute(builder: (_) => const TimeScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case calendarMore:
        return MaterialPageRoute(builder: (_) => const CalendarMoreScreen());
      case calculator:
        return MaterialPageRoute(builder: (_) => const CalculatorScreen());
      case calculatorExp:
        return MaterialPageRoute(builder: (_) => const ExpressionCalculatorScreen());
      case graph:
        return MaterialPageRoute(builder: (_) => const GraphScreen());
      case resize:
        return MaterialPageRoute(builder: (_) => const ImageScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('Lỗi',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),centerTitle: true,),
            body: Center(child: Text('Không tìm thấy trang')),
          ),
        );
    }
  }
}