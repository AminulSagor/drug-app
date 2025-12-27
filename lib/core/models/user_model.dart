class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String role;
  final int pharmacyId;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.pharmacyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? 0) as int,
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      pharmacyId: (json['pharmacy_id'] ?? 0) as int,
      createdAt: (json['created_at'] ?? '') as String,
      updatedAt: (json['updated_at'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'email': email,
    'role': role,
    'pharmacy_id': pharmacyId,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  String get fullName => '$firstName $lastName'.trim();
}
