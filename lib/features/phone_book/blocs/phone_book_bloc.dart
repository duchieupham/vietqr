import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/phone_book/events/phone_book_event.dart';
import 'package:vierqr/features/phone_book/repostiroties/phone_book_repository.dart';
import 'package:vierqr/features/phone_book/states/phone_book_state.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';
import 'package:vierqr/models/phone_book_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class PhoneBookBloc extends Bloc<PhoneBookEvent, PhoneBookState>
    with BaseManager {
  @override
  BuildContext context;

  PhoneBookBloc(this.context)
      : super(PhoneBookState(
            listPhoneBookDTO: const [],
            listPhoneBookDTOSuggest: const [],
            phoneBookDetailDTO: PhoneBookDetailDTO())) {
    on<PhoneBookEventGetList>(_getListPhoneBook);

    on<PhoneBookEventGetListPending>(_getListPhoneBookPending);
    on<PhoneBookEventGetDetail>(_getDetailPhoneBook);
    on<RemovePhoneBookEvent>(_removePhoneBook);
  }

  final repository = PhoneBookRepository();

  void _getListPhoneBook(PhoneBookEvent event, Emitter emit) async {
    try {
      if (event is PhoneBookEventGetList) {
        emit(state.copyWith(status: BlocStatus.LOADING));
        List<PhoneBookDTO> result =
            await repository.getListSavePhoneBook(userId);
        result.sort((a, b) => a.nickname.compareTo(b.nickname));
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

  void _getListPhoneBookPending(PhoneBookEvent event, Emitter emit) async {
    try {
      if (event is PhoneBookEventGetListPending) {
        final result = await repository.getListPhoneBookPending(userId);
        if (result.isNotEmpty) {
          emit(
            state.copyWith(
              listPhoneBookDTOSuggest: result,
              status: BlocStatus.NONE,
              type: PhoneBookType.GET_LIST,
            ),
          );
        } else {
          emit(state.copyWith(
              listPhoneBookDTOSuggest: [],
              status: BlocStatus.NONE,
              type: PhoneBookType.NONE));
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }

  void _getDetailPhoneBook(PhoneBookEvent event, Emitter emit) async {
    try {
      if (event is PhoneBookEventGetDetail) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            type: PhoneBookType.GET_DETAIL,
          ),
        );
        final result = await repository.getPhoneBookDetail(event.id);
        if (result.id!.isNotEmpty) {
          emit(
            state.copyWith(
              phoneBookDetailDTO: result,
              status: BlocStatus.UNLOADING,
              type: PhoneBookType.GET_DETAIL,
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

  void _removePhoneBook(PhoneBookEvent event, Emitter emit) async {
    try {
      if (event is RemovePhoneBookEvent) {
        emit(
          state.copyWith(
            status: BlocStatus.LOADING,
            type: PhoneBookType.REMOVE,
          ),
        );
        ResponseMessageDTO result = await repository.removePhoneBook(event.id);
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(state.copyWith(
              status: BlocStatus.SUCCESS, type: PhoneBookType.REMOVE));
        } else {
          emit(
            state.copyWith(
              type: PhoneBookType.REMOVE,
              status: BlocStatus.ERROR,
            ),
          );
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(status: BlocStatus.ERROR));
    }
  }
}
