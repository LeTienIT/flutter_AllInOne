
import 'dart:ui';

enum AppFeatureType {
  currency, // ĐỔI XIỀN
  unit, // ĐỔI ĐƠN VỊ
  time, // ĐẾM GIÂY - ĐẾM TỪ 0s, Đếm ngược Ns
  calendar, // ĐẾM NGÀY - Tính tổng số ngày - tống số tuần - ngày bắt đầu - kết thúc là thứ mấy. - Lịch âm - ngày hoảng đạo
  calculator, // MÁY TÍNH
  security, // TẠO MẬT KHẨU MẠNH MẼ
  resizeImage, // RESIZE ẢNH
  randomizer, // SỐ NGẪU NHIÊN - ANIMATION ĐỒNG XU
  breathing, // THỞ NHIPJ ĐIỆU
  encryption, // MÃ HÓA - GIẢI MÃ
  qrScanner, // SCAN - QUÉT ĐỌC
  deleteCache,
}

class AppFeature {
  final AppFeatureType type;
  final String title;
  final String iconPath;
  final String route;
  final int order;
  final Color color;
  final String descr;

  AppFeature({
    required this.type,
    required this.title,
    required this.iconPath,
    required this.route,
    required this.order,
    required this.color,
    required this.descr,
  });
}
