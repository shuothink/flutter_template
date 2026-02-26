import 'package:equatable/equatable.dart';

class HomeDataEntity extends Equatable {
  final String greeting;
  final List<String> items;

  const HomeDataEntity({
    required this.greeting,
    required this.items,
  });

  @override
  List<Object?> get props => [greeting, items];
}
