class PaymentMethod {
  final String id;
  final String namaBank;
  final String nomorRekening;
  final String atasNama;
  final String deskripsi;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethod({
    required this.id,
    required this.namaBank,
    required this.nomorRekening,
    required this.atasNama,
    required this.deskripsi,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      namaBank: json['nama_bank'] ?? '',
      nomorRekening: json['nomor_rekening'] ?? '',
      atasNama: json['atas_nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_bank': namaBank,
      'nomor_rekening': nomorRekening,
      'atas_nama': atasNama,
      'deskripsi': deskripsi,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
