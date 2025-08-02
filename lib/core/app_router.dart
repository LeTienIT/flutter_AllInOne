import 'package:all_in_one_tool/features/unit/unit_screen.dart';
import 'package:all_in_one_tool/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../features/currency/currency_screen.dart';

class AppRouter{
  static const String home = '/';
  static const currency = '/currency';
  static const unit = '/unit';

  static MaterialPageRoute onGenerateRouter(RouteSettings setting){
    switch(setting.name){
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case currency:
        return MaterialPageRoute(builder: (_) => const CurrencyScreen());
      case unit:
        return MaterialPageRoute(builder: (_) => const UnitScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Không tìm thấy trang')),
          ),
        );
    }
  }
}