class AuthUserModel {
  const AuthUserModel({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.extras = const {},
  });

  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final Map<String, dynamic> extras;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: json['id'].toString(),
        email: json['email'] as String?,
        displayName: json['displayName'] as String?,
        photoUrl: json['photoUrl'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
        extras: (json['extras'] as Map?)?.cast<String, dynamic>() ?? const {},
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (email != null) 'email': email,
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        if (extras.isNotEmpty) 'extras': extras,
      };
}
