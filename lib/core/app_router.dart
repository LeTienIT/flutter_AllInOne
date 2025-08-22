import 'package:all_in_one_tool/features/breathing/breathing_screen.dart';
import 'package:all_in_one_tool/features/calculator/calculator_screen.dart';
import 'package:all_in_one_tool/features/calculator/expression_screen.dart';
import 'package:all_in_one_tool/features/calculator/math_graph_screen.dart';
import 'package:all_in_one_tool/features/calendar/calendar_more_screen.dart';
import 'package:all_in_one_tool/features/calendar/calendar_screen.dart';
import 'package:all_in_one_tool/features/image/image_screen.dart';
import 'package:all_in_one_tool/features/random/coin_animation.dart';
import 'package:all_in_one_tool/features/time/time_screen.dart';
import 'package:all_in_one_tool/features/unit/unit_screen.dart';
import 'package:all_in_one_tool/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../features/breathing/breathing_animation.dart';
import '../features/cache/cache_screen.dart';
import '../features/currency/currency_screen.dart';
import '../features/password/pass_word_screen.dart';
import '../features/random/random_screen.dart';
import '../features/random/wheel_animation.dart';

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
  static const image = '/image';
  static const video = '/video';
  static const password = '/password';
  static const cache = '/delete-cache';
  static const randomizer = '/randomizer';

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
      case image:
        return MaterialPageRoute(builder: (_) => const ImageScreen());
      case password:
        return MaterialPageRoute(builder: (_) => const StrongPasswordScreen());
      case cache:
        return MaterialPageRoute(builder: (_) => CacheCleanerScreen());
      case randomizer:
        return MaterialPageRoute(builder: (_) => RandomScreen());
      case '/coin_animation':
        return MaterialPageRoute(builder: (_) => DangerousCoinFlip());
      case '/wheel_animation':
        final arg = setting.arguments as List<String>;
        return MaterialPageRoute(builder: (_) => WheelPage(values: arg,));
      case '/breathing':
        return MaterialPageRoute(builder: (_) => BreathingScreen());
      case '/breathing-run':
        final arg = setting.arguments as int;
        return MaterialPageRoute(builder: (_) => BreathingRun(mode: arg,));


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