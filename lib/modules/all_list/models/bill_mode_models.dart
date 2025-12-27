class BillModeResponse {
  final BillModeModel billMode;

  const BillModeResponse({required this.billMode});

  factory BillModeResponse.fromJson(Map<String, dynamic> json) {
    return BillModeResponse(
      billMode: json['bill_mode'] is Map<String, dynamic>
          ? BillModeModel.fromJson(json['bill_mode'] as Map<String, dynamic>)
          : const BillModeModel.empty(),
    );
  }
}

class BillModeModel {
  final int id;
  final String status;
  final String feature;
  final num comissionPercent;
  final int saleMode;
  final int billMode; // 0/1
  final int pharmacyId;
  final String createdAt;
  final String updatedAt;

  const BillModeModel({
    required this.id,
    required this.status,
    required this.feature,
    required this.comissionPercent,
    required this.saleMode,
    required this.billMode,
    required this.pharmacyId,
    required this.createdAt,
    required this.updatedAt,
  });

  const BillModeModel.empty()
    : id = 0,
      status = '',
      feature = '',
      comissionPercent = 0,
      saleMode = 0,
      billMode = 0,
      pharmacyId = 0,
      createdAt = '',
      updatedAt = '';

  factory BillModeModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      return num.tryParse(v.toString()) ?? 0;
    }

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return BillModeModel(
      id: parseInt(json['id']),
      status: (json['status'] ?? '') as String,
      feature: (json['feature'] ?? '') as String,
      comissionPercent: parseNum(json['comissionPercent']),
      saleMode: parseInt(json['sale_mode']),
      billMode: parseInt(json['bill_mode']),
      pharmacyId: parseInt(json['pharmacy_id']),
      createdAt: (json['created_at'] ?? '') as String,
      updatedAt: (json['updated_at'] ?? '') as String,
    );
  }
}

class UpdateBillModeResponse {
  final String message;
  final String status;

  const UpdateBillModeResponse({required this.message, required this.status});

  factory UpdateBillModeResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBillModeResponse(
      message: (json['message'] ?? '') as String,
      status: (json['status'] ?? '') as String,
    );
  }
}
