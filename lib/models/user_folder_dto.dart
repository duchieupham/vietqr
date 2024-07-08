class UserFolder {
  String fullName;
  String role;
  String userId;
  String phoneNo;
  String imageId;

  UserFolder({
    required this.fullName,
    required this.role,
    required this.userId,
    required this.phoneNo,
    required this.imageId,
  });

  factory UserFolder.fromJson(Map<String, dynamic> json) {
    return UserFolder(
      fullName: json['fullName'],
      role: json['role'],
      userId: json['userId'],
      phoneNo: json['phoneNo'],
      imageId: json['imageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'role': role,
      'userId': userId,
      'phoneNo': phoneNo,
      'imageId': imageId,
    };
  }
}
