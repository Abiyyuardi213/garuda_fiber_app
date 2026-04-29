class ShippingService {
  final String id;
  final String nama;
  final String kode;
  final double biayaDasar;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShippingService({
    required this.id,
    required this.nama,
    required this.kode,
    required this.biayaDasar,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingService.fromJson(Map<String, dynamic> json) {
    return ShippingService(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      kode: json['kode'] ?? '',
      biayaDasar: double.tryParse(json['biaya_dasar'].toString()) ?? 0.0,
      status: json['status'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kode': kode,
      'biaya_dasar': biayaDasar,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
