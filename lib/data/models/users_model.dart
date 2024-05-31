class Users {
  final String firstName;
  final String lastName;
  final String email;
  final String userRole;
  final String phoneNumber;
  final String imageUrl;

  Users({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userRole,
    required this.phoneNumber,
    required this.imageUrl,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userRole: json['userRole'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userRole': userRole,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }
}
