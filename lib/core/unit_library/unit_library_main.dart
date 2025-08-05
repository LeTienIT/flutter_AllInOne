import 'package:all_in_one_tool/core/unit_library/unit_definition.dart';
import 'package:all_in_one_tool/core/unit_library/units_data.dart';
import 'package:intl/intl.dart';

class UnitLibrary {
  final formatter = NumberFormat('#,##0.####', 'vi_VN');

  /// Trả ra tên tiếng việt các loại từ mã
  static String tenLoai(UnitCategory ten){
    switch(ten){
      case UnitCategory.chieuDai:
        return 'Chiều dài';
      case UnitCategory.dienTich:
        return 'Diện tích';
      case UnitCategory.khoiLuong:
        return 'Khối lượng';
      case UnitCategory.nhietDo:
        return 'Nhiệt độ';
      case UnitCategory.theTich:
        return 'Thể tích';
      case UnitCategory.thoiGian:
        return 'Thời gian';
      case UnitCategory.tocDo:
        return 'Tốc độ';
      default:
        return 'Không xác định';
    }
  }

  /// Hiển thị giá trị chuyển đổi đẹp - dễ đọc
  static String formatSoDonVi(double value) {
    if (value >= 1000 || value <= -1000) {
      return NumberFormat('#,##0.##', 'vi_VN').format(value);
    } else if (value >= 0.01 || value <= -0.01) {
      return NumberFormat('#,##0.####', 'vi_VN').format(value);
    } else {
      return value.toStringAsPrecision(6).replaceAll('.', ',');
    }
  }
  /// Trả về toàn bộ đơn vị
  static List<UnitDefinition> getAllUnits() => tatCaDonVi;

  /// Lọc đơn vị theo nhóm
  static List<UnitDefinition> getUnitsByCategory(UnitCategory nhom) {
    return tatCaDonVi.where((u) => u.nhom == nhom).toList();
  }

  /// Lấy đơn vị theo unitId (vd: 'km', 'ha')
  static UnitDefinition? getUnitById(String id) {
    return tatCaDonVi.firstWhere(
          (u) => u.unitId == id,
      orElse: () => throw Exception('Không tìm thấy đơn vị với id "$id"'),
    );
  }

  static double convert(double value, String fromId, String toId) {
    final from = getUnitById(fromId)!;
    final to = getUnitById(toId)!;

    // 1. Kiểm tra xem cùng nhóm không
    if (from.nhom != to.nhom) {
      throw Exception(
        'Không thể chuyển đổi giữa 2 đơn vị khác nhóm: ${from.nhom} và ${to.nhom}',
      );
    }

    // 2. Nếu là nhiệt độ → dùng công thức riêng
    if (from.nhom == UnitCategory.nhietDo) {
      return _convertNhietDo(value, fromId, toId);
    }

    // 3. Các nhóm còn lại → dùng hệ số tuyến tính
    final base = value * from.heSoToiBase;
    return base / to.heSoToiBase;
  }

  static double _convertNhietDo(double value, String fromId, String toId) {
    // B1: Đưa về độ C
    double toCelsius(String id, double val) {
      switch (id) {
        case 'c':
          return val;
        case 'f':
          return (val - 32) * 5 / 9;
        case 'k':
          return val - 273.15;
        default:
          throw Exception('Không hỗ trợ chuyển đổi từ đơn vị "$id"');
      }
    }

    // B2: Từ độ C sang đơn vị đích
    double fromCelsius(String id, double val) {
      switch (id) {
        case 'c':
          return val;
        case 'f':
          return val * 9 / 5 + 32;
        case 'k':
          return val + 273.15;
        default:
          throw Exception('Không hỗ trợ chuyển đổi sang đơn vị "$id"');
      }
    }

    final celsius = toCelsius(fromId, value);
    return fromCelsius(toId, celsius);
  }

}