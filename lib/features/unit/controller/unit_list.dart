import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart' as uc;
import '../model/unit_model.dart';

final supportedUnitsProvider = Provider<Map<UnitGroup, List<dynamic>>>((ref) {
  return {
    UnitGroup.length: [
      uc.LENGTH.kilometers,
      uc.LENGTH.meters,
      uc.LENGTH.centimeters,
      uc.LENGTH.millimeters,
      uc.LENGTH.micrometers,
      uc.LENGTH.nanometers,
      uc.LENGTH.miles,
      uc.LENGTH.yards,
      uc.LENGTH.feet,
      uc.LENGTH.inches,
    ],
    UnitGroup.mass: [
      uc.MASS.tons,
      uc.MASS.kilograms,
      uc.MASS.grams,
      uc.MASS.milligrams,
      uc.MASS.micrograms,
      uc.MASS.stones,
      uc.MASS.pounds,
      uc.MASS.ounces,
    ],
    UnitGroup.temperature: [
      uc.TEMPERATURE.celsius,
      uc.TEMPERATURE.fahrenheit,
      uc.TEMPERATURE.kelvin,
      uc.TEMPERATURE.rankine,
      uc.TEMPERATURE.reamur,
    ],
    UnitGroup.area: [
      uc.AREA.squareKilometers,
      uc.AREA.squareMeters,
      uc.AREA.squareCentimeters,
      uc.AREA.squareMillimeters,
      uc.AREA.squareCentimeters,
      uc.AREA.squareMiles,
      uc.AREA.squareMeters,
      uc.AREA.squareFeet,
      uc.AREA.squareInches,
      uc.AREA.hectares,
      uc.AREA.acres,
    ],
    UnitGroup.force: [
      uc.FORCE.newton,
      uc.FORCE.poundForce,
      uc.FORCE.kilogramForce,
      uc.FORCE.dyne,
    ],
    UnitGroup.pressure: [
      uc.PRESSURE.pascal,
      uc.PRESSURE.bar,
      uc.PRESSURE.millibar,
      uc.PRESSURE.psi,
      uc.PRESSURE.atmosphere,
      uc.PRESSURE.inchOfMercury,
    ],
    UnitGroup.speed: [
      uc.SPEED.metersPerSecond,
      uc.SPEED.kilometersPerHour,
      uc.SPEED.milesPerHour,
      uc.SPEED.feetsPerSecond,
      uc.SPEED.knots,
    ],
    UnitGroup.time: [
      uc.TIME.nanoseconds,
      uc.TIME.microseconds,
      uc.TIME.milliseconds,
      uc.TIME.seconds,
      uc.TIME.minutes,
      uc.TIME.hours,
      uc.TIME.days,
    ],
  };
});

