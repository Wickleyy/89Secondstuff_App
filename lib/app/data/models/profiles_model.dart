class Profile {
  final String id;
  final String? email;
  final String role;
  final String? fullName;

  Profile({
    required this.id,
    this.email,
    required this.role,
    this.fullName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString(),
      role: json['role']?.toString() ?? 'user',
      fullName: json['full_name']?.toString(),
    );
  }
}
