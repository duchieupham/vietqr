import 'package:equatable/equatable.dart';

class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

class PermissionDeniedRequestState extends PermissionState {}

class PermissionInitialState extends PermissionState {}

class PermissionLoadingState extends PermissionState {}

class PermissionSmsDeniedState extends PermissionState {}

class PermissionCameraDeniedState extends PermissionState {}

class PermissionSMSAllowedState extends PermissionState {}

class PermissionCameraAllowsedState extends PermissionState {}

class PermissionErrorState extends PermissionState {}

class PermissionAllowedState extends PermissionState {}
