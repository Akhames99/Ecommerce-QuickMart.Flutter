class UserData {
  final String id;
  final String userName;
  final String email;
  final String createdAt;

  UserData({
    required this.id,
    required this.userName,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
