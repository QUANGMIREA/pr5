class User {
  final String id;
  final String username;

  const User({required this.id, required this.username});

  Map<String, dynamic> toJson() => {'id': id, 'username': username};

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'] as String, username: json['username'] as String);
}
