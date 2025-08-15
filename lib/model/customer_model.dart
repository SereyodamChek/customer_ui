class CustomerModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String address;
  final String phoneNumber;
  final String dateOfBirth;
  final String status;
  final String? imageUrl;
  CustomerModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    this.address = '',
    this.phoneNumber = '',
    this.dateOfBirth = '',
    this.status = '',
    this.imageUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'status': status,
      'imageUrl': imageUrl ?? '',
    };
  }
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
