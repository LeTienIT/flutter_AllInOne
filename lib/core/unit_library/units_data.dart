import 'package:all_in_one_tool/core/unit_library/unit_definition.dart';

const List<UnitDefinition> tatCaDonVi = [
  // --- Chiều dài ---
  UnitDefinition(unitId: 'km', ten: 'Kilômét', kyHieu: 'km', heSoToiBase: 1000, nhom: UnitCategory.chieuDai),
  UnitDefinition(unitId: 'm', ten: 'Mét', kyHieu: 'm', heSoToiBase: 1, nhom: UnitCategory.chieuDai),
  UnitDefinition(unitId: 'dm', ten: 'Đềximét', kyHieu: 'dm', heSoToiBase: 0.1, nhom: UnitCategory.chieuDai),
  UnitDefinition(unitId: 'cm', ten: 'Xentimét', kyHieu: 'cm', heSoToiBase: 0.01, nhom: UnitCategory.chieuDai),
  UnitDefinition(unitId: 'mm', ten: 'Milimét', kyHieu: 'mm', heSoToiBase: 0.001, nhom: UnitCategory.chieuDai),
  UnitDefinition(unitId: 'nmi', ten: 'Hải lý', kyHieu: 'nmi', heSoToiBase: 1852, nhom: UnitCategory.chieuDai, moTa: 'Đơn vị đo khoảng cách hàng hải quốc tế. 1 hải lý = 1.852 mét.'),
  UnitDefinition(unitId: 'dặm', ten: 'Dặm ta', kyHieu: '', heSoToiBase: 444, nhom: UnitCategory.chieuDai, moTa: 'Đơn vị đo cổ truyền của Việt Nam. 1 dặm ta ≈ 444 mét.'),
  UnitDefinition(unitId: 'tấc', ten: 'Tấc', kyHieu: '', heSoToiBase: 0.1, nhom: UnitCategory.chieuDai, moTa: 'Đơn vị cổ. 1 tấc = 0,1 mét (tức 10 cm).'),
  UnitDefinition(unitId: 'ly', ten: 'Ly', kyHieu: '', heSoToiBase: 0.0001, nhom: UnitCategory.chieuDai, moTa: 'Đơn vị rất nhỏ trong hệ cổ. 1 ly = 0,1 mm (tức 0,0001 m).'),

  // --- Diện tích ---
  UnitDefinition(unitId: 'm2', ten: 'Mét vuông', kyHieu: 'm²', heSoToiBase: 1, nhom: UnitCategory.dienTich),
  UnitDefinition(unitId: 'ha', ten: 'Hecta', kyHieu: 'ha', heSoToiBase: 10000, nhom: UnitCategory.dienTich),
  UnitDefinition(unitId: 'sào_bắc', ten: 'Sào (Bắc)', kyHieu: '', heSoToiBase: 360, nhom: UnitCategory.dienTich, moTa: 'Đơn vị cổ đo đất ở miền Bắc. 1 sào Bắc = 360 m².'),
  UnitDefinition(unitId: 'sào_nam', ten: 'Sào (Nam)', kyHieu: '', heSoToiBase: 1000, nhom: UnitCategory.dienTich, moTa: 'Đơn vị đo đất ở miền Nam. 1 sào Nam = 1.000 m².'),
  UnitDefinition(unitId: 'mẫu_bắc', ten: 'Mẫu (Bắc)', kyHieu: '', heSoToiBase: 3600, nhom: UnitCategory.dienTich, moTa: 'Đơn vị cổ. 1 mẫu Bắc = 10 sào Bắc = 3.600 m².'),
  UnitDefinition(unitId: 'mẫu_nam', ten: 'Mẫu (Nam)', kyHieu: '', heSoToiBase: 10000, nhom: UnitCategory.dienTich, moTa: '	Đơn vị đo đất lớn ở miền Nam. 1 mẫu Nam = 10 sào Nam = 10.000 m².'),

  // --- Khối lượng ---
  UnitDefinition(unitId: 't', ten: 'Tấn', kyHieu: 't', heSoToiBase: 1000, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'tạ', ten: 'Tạ', kyHieu: 'tạ', heSoToiBase: 100, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'yến', ten: 'Yến', kyHieu: 'yến', heSoToiBase: 10, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'kg', ten: 'Kilôgam', kyHieu: 'kg', heSoToiBase: 1, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'g', ten: 'Gam', kyHieu: 'g', heSoToiBase: 0.001, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'mg', ten: 'Miligam', kyHieu: 'mg', heSoToiBase: 0.000001, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'lạng', ten: 'Lạng', kyHieu: '', heSoToiBase: 0.1, nhom: UnitCategory.khoiLuong),
  UnitDefinition(unitId: 'chỉ', ten: 'Chỉ (vàng)', kyHieu: '', heSoToiBase: 0.00375, nhom: UnitCategory.khoiLuong, moTa: 'Đơn vị cổ. 1 chỉ = 3,75 gam. Thường dùng đo vàng/bạc.'),
  UnitDefinition(unitId: 'phân', ten: 'Phân (vàng)', kyHieu: '', heSoToiBase: 0.000375, nhom: UnitCategory.khoiLuong, moTa: 'Đơn vị nhỏ hơn chỉ. 1 phân = 0,375 gam'),
  UnitDefinition(unitId: 'lb', ten: 'Pound (pao)', kyHieu: 'lb', heSoToiBase: 0.45359237, nhom: UnitCategory.khoiLuong, moTa: 'Đơn vị khối lượng phổ biến ở Mỹ. 1 pound (pao) = 0,45359237 kg.',),

  // --- Thể tích ---
  UnitDefinition(unitId: 'm3', ten: 'Mét khối', kyHieu: 'm³', heSoToiBase: 1, nhom: UnitCategory.theTich),
  UnitDefinition(unitId: 'l', ten: 'Lít', kyHieu: 'l', heSoToiBase: 0.001, nhom: UnitCategory.theTich),
  UnitDefinition(unitId: 'ml', ten: 'Mililít', kyHieu: 'ml', heSoToiBase: 0.000001, nhom: UnitCategory.theTich),
  UnitDefinition(unitId: 'cm3', ten: 'Centimét khối', kyHieu: 'cm³', heSoToiBase: 0.000001, nhom: UnitCategory.theTich),
  UnitDefinition(unitId: 'dl', ten: 'Đềxilít', kyHieu: 'dl', heSoToiBase: 0.0001, nhom: UnitCategory.theTich),

  // --- Thời gian ---
  UnitDefinition(unitId: 's', ten: 'Giây', kyHieu: 's', heSoToiBase: 1, nhom: UnitCategory.thoiGian),
  UnitDefinition(unitId: 'min', ten: 'Phút', kyHieu: 'min', heSoToiBase: 60, nhom: UnitCategory.thoiGian),
  UnitDefinition(unitId: 'h', ten: 'Giờ', kyHieu: 'h', heSoToiBase: 3600, nhom: UnitCategory.thoiGian),
  UnitDefinition(unitId: 'ngày', ten: 'Ngày', kyHieu: '', heSoToiBase: 86400, nhom: UnitCategory.thoiGian),
  UnitDefinition(unitId: 'tuần', ten: 'Tuần', kyHieu: '', heSoToiBase: 604800, nhom: UnitCategory.thoiGian),

  // --- Nhiệt độ ---
  // Hệ số không dùng được cho nhiệt độ tuyến tính — cần xử lý riêng, nhưng vẫn liệt kê để hiển thị UI
  UnitDefinition(unitId: 'c', ten: 'Độ C', kyHieu: '°C', heSoToiBase: 1, nhom: UnitCategory.nhietDo),
  UnitDefinition(unitId: 'f', ten: 'Độ F', kyHieu: '°F', heSoToiBase: 1, nhom: UnitCategory.nhietDo, moTa: 'Đơn vị đo nhiệt độ phổ biến ở Mỹ. 0°F = -17,8°C. 32°F = nhiệt độ nước đóng băng.'),
  UnitDefinition(unitId: 'k', ten: 'Độ K', kyHieu: 'K', heSoToiBase: 1, nhom: UnitCategory.nhietDo, moTa: 'Đơn vị đo tuyệt đối của nhiệt độ trong vật lý. 0K = nhiệt độ thấp nhất có thể đạt. 1K = 1°C.'),

  // --- Tốc độ ---
  UnitDefinition(unitId: 'mps', ten: 'Mét/giây', kyHieu: 'm/s', heSoToiBase: 1, nhom: UnitCategory.tocDo),
  UnitDefinition(unitId: 'kmh', ten: 'Kilômét/giờ', kyHieu: 'km/h', heSoToiBase: 1000 / 3600, nhom: UnitCategory.tocDo),
  UnitDefinition(unitId: 'mph', ten: 'Dặm/giờ (mile)', kyHieu: 'mph', heSoToiBase: 1609.344 / 3600, nhom: UnitCategory.tocDo),
  UnitDefinition(unitId: 'kn', ten: 'Hải lý/giờ', kyHieu: 'kn', heSoToiBase: 1852 / 3600, nhom: UnitCategory.tocDo),
];
