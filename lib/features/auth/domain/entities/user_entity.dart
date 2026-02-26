import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String username;
  final String? email;
  final String? avatar;

  const UserEntity({
    required this.userId,
    required this.username,
    this.email,
    this.avatar,
  });

  @override
  List<Object?> get props => [userId, username, email, avatar];
}
