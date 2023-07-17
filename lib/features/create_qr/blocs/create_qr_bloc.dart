import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/create_qr/events/create_qr_event.dart';
import 'package:vierqr/features/create_qr/states/create_qr_state.dart';

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> with BaseManager {
  @override
  final BuildContext context;

  CreateQRBloc(this.context) : super(const CreateQRState()) {}
}
