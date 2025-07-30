import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final int currentStreak;
  final List<String> badges;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.currentStreak,
    required this.badges,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    int? currentStreak,
    List<String>? badges,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      currentStreak: currentStreak ?? this.currentStreak,
      badges: badges ?? this.badges,
    );
  }

  @override
  List<Object?> get props => [id, email, name, createdAt, currentStreak, badges];
}
