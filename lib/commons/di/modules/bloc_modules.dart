import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/connect_gg_chat/blocs/connect_gg_chat_bloc.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/transaction_detail/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/navigator/app_navigator.dart';

class BlocModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt
      ..registerLazySingleton(
        () => NetworkBloc(connectivity: Connectivity()),
      )
      ..registerLazySingleton(
        () => ConnectGgChatBloc(),
      )
      ..registerLazySingleton(
        // (param1, param2) => BankBloc(param1 as BuildContext),
        () => BankBloc(NavigationService.context!),
      )
      ..registerFactoryParam(
        (param1, param2) => TransactionBloc(
          transactionId: param1 as String,
          transactionRepository: getIt.get<TransactionRepository>(),
        ),
      )
      ..registerFactoryParam(
        (param1, param2) => LoginBloc(
          param1 as BuildContext,
        ),
      );
  }
}
