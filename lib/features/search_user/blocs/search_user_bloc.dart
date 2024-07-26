import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/bank_detail/repositories/share_bdsd_repository.dart';
import 'package:vierqr/features/connect_lark_old/repositories/connect_lark_repository.dart';
import 'package:vierqr/features/connect_telegram_old/repositories/connect_telegram_repository.dart';
import 'package:vierqr/features/search_user/events/search_user_event.dart';
import 'package:vierqr/features/search_user/states/search_user_state.dart';
import 'package:vierqr/models/detail_group_dto.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState>
    with BaseManager {
  @override
  final BuildContext context;
  final List<AccountMemberDTO> listInit;

  SearchUserBloc(this.context, this.listInit)
      : super(
          SearchUserState(
            members: const [],
            insertMembers: [...listInit],
          ),
        ) {
    on<UpdateMembersEvent>(_updateMembers);
    on<InsertMemberToList>(_insertMember);
    on<SearchMemberEvent>(_searchMember);
  }

  ShareBDSDRepository repository = const ShareBDSDRepository();

  ConnectLarkRepository larkRepository = const ConnectLarkRepository();
  ConnectTelegramRepository telegramRepository = const ConnectTelegramRepository();

  void _searchMember(SearchUserEvent event, Emitter emit) async {
    try {
      if (event is SearchMemberEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: SearchUserType.SEARCH_MEMBER));

        final List<AccountMemberDTO> list = await repository.searchMemberNew(
            event.terminalId, event.value, event.type);

        List<AccountMemberDTO> listInsert = [...state.insertMembers];

        for (var e in listInsert) {
          int index = list.indexWhere((element) => element.id == e.id);
          if (index != -1) {
            list.removeAt(index);
            list.insert(index, e);
          }
        }

        emit(state.copyWith(
            status: BlocStatus.NONE,
            members: list,
            request: SearchUserType.NONE,
            isLoading: false,
            isEmpty: list.isEmpty));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: SearchUserType.NONE));
    }
  }

  void _updateMembers(SearchUserEvent event, Emitter emit) async {
    try {
      if (event is UpdateMembersEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: SearchUserType.NONE));

        emit(state.copyWith(
          status: BlocStatus.NONE,
          members: [],
          request: SearchUserType.CLEAR_MEMBER,
          isLoading: false,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: SearchUserType.NONE));
    }
  }

  void _insertMember(SearchUserEvent event, Emitter emit) async {
    try {
      if (event is InsertMemberToList) {
        emit(state.copyWith(
            status: BlocStatus.NONE, request: SearchUserType.NONE));

        List<AccountMemberDTO> list = [...state.members];
        List<AccountMemberDTO> insertList = [...state.insertMembers];

        insertList.add(event.dto);

        int index = list.indexWhere((element) => element.id == event.dto.id);
        list.removeAt(index);
        event.dto.existed = 1;
        list.insert(index, event.dto);

        emit(state.copyWith(
          status: BlocStatus.NONE,
          members: list,
          insertMembers: insertList,
          request: SearchUserType.INSERT_MEMBER,
          isLoading: false,
        ));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.NONE, request: SearchUserType.NONE));
    }
  }

// void _shareBDSD(SearchUserEvent event, Emitter emit) async {
//   try {
//     if (event is ShareUserBDSDEvent) {
//       emit(state.copyWith(
//           userIdSelect: event.body['userId'],
//           status: BlocStatus.LOADING_SHARE,
//           request: SearchUserType.SHARE_BDSD));
//
//       final responseMessageDTO = await repository.shareBDSD(event.body);
//       if (responseMessageDTO.status == Stringify.RESPONSE_STATUS_SUCCESS) {
//         emit(state.copyWith(
//             status: BlocStatus.UNLOADING,
//             request: SearchUserType.SHARE_BDSD));
//       } else {
//         emit(
//           state.copyWith(
//             msg: ErrorUtils.instance
//                 .getErrorMessage(responseMessageDTO.message),
//             request: SearchUserType.ERROR,
//             status: BlocStatus.UNLOADING,
//           ),
//         );
//       }
//     }
//   } catch (e) {
//     LOG.error(e.toString());
//     ResponseMessageDTO responseMessageDTO =
//         const ResponseMessageDTO(status: 'FAILED', message: 'E05');
//     emit(
//       state.copyWith(
//         msg: ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
//         request: SearchUserType.ERROR,
//         status: BlocStatus.UNLOADING,
//       ),
//     );
//   }
// }
}
