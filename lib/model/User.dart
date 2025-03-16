class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final double height;
  final double weight;

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.weight,
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
}
