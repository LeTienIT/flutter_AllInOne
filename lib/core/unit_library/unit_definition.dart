
enum UnitCategory {
  chieuDai,
  dienTich,
  khoiLuong,
  theTich,
  thoiGian,
  nhietDo,
  tocDo,
}

class UnitDefinition {
  final String unitId;       // mã nội bộ (vd: "km", "m", "ha",...)
  final String ten;          // tên tiếng Việt
  final String kyHieu;       // ký hiệu (hiển thị)
  final double heSoToiBase;  // hệ số quy đổi về đơn vị chuẩn (vd: mét, mét vuông,...)
  final UnitCategory nhom;   // nhóm đơn vị
  final String? moTa;

  const UnitDefinition({
    required this.unitId,
    required this.ten,
    required this.kyHieu,
    required this.heSoToiBase,
    required this.nhom,
    this.moTa,
  });
}
