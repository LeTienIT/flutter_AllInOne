import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart' as uc;

import '../model/unit_model.dart';

final unitConvertProvider = NotifierProvider<UnitConvertNotifier, AsyncValue<double>>(UnitConvertNotifier.new);

class UnitConvertNotifier extends Notifier<AsyncValue<double>> {
  @override
  AsyncValue<double> build() => const AsyncData(0);

  Future<void> convert({required UnitGroup group, required dynamic fromUnit, required dynamic toUnit, required double value,}) async {
    state = const AsyncLoading();
    try {
      dynamic unit;
      switch (group) {
        case UnitGroup.length:
          unit = uc.Length()..convert(fromUnit, value);
          state = AsyncData(unit.getUnit(toUnit).value ?? 0);
          break;
        case UnitGroup.mass:
          unit = uc.Mass()..convert(fromUnit, value);
          state = AsyncData(unit.getUnit(toUnit).value ?? 0);
          break;
        case UnitGroup.temperature:
          unit = uc.Temperature();
          unit.convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        case UnitGroup.area:
          unit = uc.Area()..convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        case UnitGroup.force:
          unit = uc.Force()..convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        case UnitGroup.pressure:
          unit = uc.Pressure()..convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        case UnitGroup.speed:
          unit = uc.Speed()..convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        case UnitGroup.time:
          unit = uc.Time()..convert(fromUnit, value);
          final result = unit.getUnit(toUnit).value;
          state = AsyncData(result ?? 0);
          break;
        default:
          throw Exception("Chưa hỗ trợ nhóm đơn vị này");
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }

  }
}
