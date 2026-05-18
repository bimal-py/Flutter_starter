import 'package:equatable/equatable.dart';

class PickedImageEntity extends Equatable {
  const PickedImageEntity({required this.path});

  final String path;

  @override
  List<Object?> get props => [path];
}
