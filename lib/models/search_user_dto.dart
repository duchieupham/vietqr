class SearchUser {
  String fullName;
  String userId;
  String phoneNo;
  String imageId;

  SearchUser({
    required this.fullName,
    required this.userId,
    required this.phoneNo,
    required this.imageId,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      fullName: json['fullName'],
      userId: json['userId'],
      phoneNo: json['phoneNo'],
      imageId: json['imageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'userId': userId,
      'phoneNo': phoneNo,
      'imageId': imageId,
    };
  }
}
