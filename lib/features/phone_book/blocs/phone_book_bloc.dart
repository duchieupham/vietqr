import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';

class PhoneBookBloc extends Bloc<PhoneBookEvent, PhoneBookState>
    with BaseManager {
  @override
  BuildContext context;

  PhoneBookBloc(this.context) : super(PhoneBookState()) {}


}
