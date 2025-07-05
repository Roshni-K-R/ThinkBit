class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? blockedUntil;
  final String? status;
  final String? bio;
  final int? followerCount;
  final int? followingCount;


  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.blockedUntil,
    this.status,
    this.bio,
    this.followerCount,
    this.followingCount,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      blockedUntil: map['blocked_until'] != null
          ? DateTime.parse(map['blocked_until'])
          : null,
      status: map['status'] as String?,
      bio: map['bio'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (blockedUntil != null) 'blocked_until': blockedUntil!.toIso8601String(),
      if (status != null) 'status': status,
      if(bio != null) 'bio':bio,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
   String? avatarUrl,
    DateTime? blockedUntil,
    String? status,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      blockedUntil: blockedUntil ?? this.blockedUntil,
      status: status ?? this.status,
      bio: bio?? this.bio,
    );
  }


}
