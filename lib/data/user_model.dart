class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.fromString(map['role'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
    };
  }
}

enum UserRole {
  customer,
  agent,
  admin;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'agent':
        return UserRole.agent;
      case 'admin':
        return UserRole.admin;
      case "customer":
      default:
        return UserRole.customer;
    }
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}
