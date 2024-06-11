import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/connect_gg_chat/blocs/connect_gg_chat_bloc.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/transaction_detail/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';

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
    // ..registerFactory(
    //   () => EditProfileBloc(
    //     editProfileInteractor: getIt.get<EditProfileInteractor>(),
    //     authInteractor: getIt.get<AuthInteractor>(),
    //     authBloc: getIt.get<AuthBloc>(),
    //   ),
    // );
  }
}
