import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavigationDTO extends Equatable {
  final String name;
  final String assetsActive;
  final String assetsUnActive;
  final Widget page;

  const NavigationDTO({
    required this.name,
    required this.assetsActive,
    required this.assetsUnActive,
    required this.page,
  });

  @override
  List<Object?> get props => [
        name,
        assetsActive,
        assetsUnActive,
        page,
      ];
}
