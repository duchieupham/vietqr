import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/repostiroties/phone_book_repository.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';

class PhoneBookBloc extends Bloc<PhoneBookEvent, PhoneBookState>
    with BaseManager {
  @override
  BuildContext context;

  PhoneBookBloc(this.context)
      : super(const PhoneBookState(listPhoneBookDTO: [])) {
    on<PhoneBookEventGetList>(_getListPhoneBook);
  }

  final repository = PhoneBookRepository();

  void _getListPhoneBook(PhoneBookEvent event, Emitter emit) async {
    try {
      if (event is PhoneBookEventGetList) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        final result = await repository.getListSavePhoneBook(userId);
        if (result.isNotEmpty) {
          emit(
            state.copyWith(
              listPhoneBookDTO: result,
              status: BlocStatus.UNLOADING,
              type: PhoneBookType.GET_LIST,
            ),
          );
        } else {
          emit(state.copyWith(
              status: BlocStatus.UNLOADING, type: PhoneBookType.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}
