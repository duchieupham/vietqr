import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/permission/events/permission_event.dart';
import 'package:vierqr/features/permission/repositories/permission_repository.dart';
import 'package:vierqr/features/permission/states/permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitialState()) {
    on<PermissionEventGetStatus>(_getPermissionStatus);
    on<PermissionEventRequest>(_requestPermissions);
  }

  PermissionRepository permissionRepository = const PermissionRepository();

  void _getPermissionStatus(PermissionEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventGetStatus) {
        Map<String, PermissionStatus> permissions =
            await permissionRepository.checkPermissions();
        // if (!permissions['sms']!.isGranted) {
        //   emit(PermissionSmsDeniedState());
        // } else {
        //   emit(PermissionSMSAllowedState());
        // }
        if (!permissions['camera']!.isGranted) {
          emit(PermissionCameraDeniedState());
        } else {
          emit(PermissionCameraAllowsedState());
        }
        // if (permissions['sms']!.isGranted && permissions['camera']!.isGranted) {
        //   emit(PermissionAllowedState());
        //}
      }
    } catch (e) {
      LOG.error('Error at _getPermissionStatus - PermissionBloc: $e');
      emit(PermissionErrorState());
    }
  }

  void _requestPermissions(PermissionEvent event, Emitter emit) async {
    try {
      if (event is PermissionEventRequest) {
        emit(PermissionLoadingState());
        bool check = await permissionRepository.requestPermissions();
        if (check) {
          emit(PermissionAllowedState());
        } else {
          emit(PermissionDeniedRequestState());
        }
      }
    } catch (e) {
      print('Error at _requestPermissions - PermissionBloc: $e');
      emit(PermissionErrorState());
    }
  }
}
