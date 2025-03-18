class User {
  final String uid;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final double height;
  final double weight;
  final String profilePicture;

  User({
    this.uid = '',
    required this.email,
    this.password = '',
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.weight,
    this.profilePicture = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'height': height,
      'weight': weight,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      height: map['height'] ?? 0.0,
      weight: map['weight'] ?? 0.0,
      profilePicture: map['profilePicture'] ?? '',
    );
  }
}
