import 'package:equatable/equatable.dart';

class NavigationDTO extends Equatable {
  final String name;
  final String assetsActive;
  final String assetsUnActive;
  final int index;

  const NavigationDTO({
    required this.name,
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
      ];
}
