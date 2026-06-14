class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isAdmin,
  });

  final String id;
  final String email;
  final String displayName;
  final bool isAdmin;

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      isAdmin: data['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'isAdmin': isAdmin,
    };
  }
}
