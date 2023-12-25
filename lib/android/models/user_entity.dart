class User {
  final int? id;
  final String name;
  final String password;
  final String email;
  final String phone;
  final int? imageId;
  // TODO future sugestion: create a adopt counter

  const User({
    this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    this.imageId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      imageId: json['image_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['password'] = password;
    data['email'] = email;
    data['phone'] = phone;
    data['image_id'] = imageId;

    return data;
  }
}
