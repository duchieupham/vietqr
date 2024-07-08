class UserRole {
  String userId;
  String role;

  UserRole({
    required this.userId,
    required this.role,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      userId: json['userId'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': role,
    };
  }
}

class CreateFolderDTO {
  String title;
  String description;
  String userId;
  List<UserRole> userRoles;
  List<String> qrIds;

  CreateFolderDTO({
    required this.title,
    required this.description,
    required this.userId,
    required this.userRoles,
    required this.qrIds,
  });

  factory CreateFolderDTO.fromJson(Map<String, dynamic> json) {
    return CreateFolderDTO(
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      userRoles: List<UserRole>.from(
          json['userRoles'].map((data) => UserRole.fromJson(data))),
      qrIds: List<String>.from(json['qrIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'userRoles': userRoles.map((userRole) => userRole.toJson()).toList(),
      'qrIds': qrIds,
    };
  }
}
