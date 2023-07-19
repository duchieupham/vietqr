import 'package:equatable/equatable.dart';

class NavigationDTO extends Equatable {
  final String name;
  final String label;
  final String assetsActive;
  final String assetsUnActive;
  final int index;

  const NavigationDTO({
    required this.name,
    required this.label,
    required this.assetsActive,
    required this.assetsUnActive,
    required this.index,
  });

  @override
  List<Object?> get props => [
        name,
        assetsActive,
        assetsUnActive,
        index,
        label,
      ];
}
