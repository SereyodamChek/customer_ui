class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String comfirmPassword;
  final String? imageUrl;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.comfirmPassword = '',
    this.imageUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'comfirmPassword': comfirmPassword,
      'imageUrl': imageUrl ?? '',
    };
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '', 
      comfirmPassword: json['comfirmPassword'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
