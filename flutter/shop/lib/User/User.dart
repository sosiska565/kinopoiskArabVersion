class User {
  final int? id;
  final String name;
  final String nickname;
  final String password;
  final String email;

  User({this.id, required this.name, required this.nickname, required this.password, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      password: json['password'],
      email: json['email'],
    );
  }
}