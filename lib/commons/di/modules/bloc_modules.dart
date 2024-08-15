import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail_new/blocs/transaction_bloc.dart';
import 'package:vierqr/features/connect_media/blocs/connect_media_bloc.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/my_vietqr/bloc/vietqr_store_bloc.dart';
import 'package:vierqr/features/network/network_bloc.dart';
import 'package:vierqr/features/qr_feed/blocs/qr_feed_bloc.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/repositories/register_repository.dart';
import 'package:vierqr/features/transaction_detail/blocs/transaction_bloc.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/navigator/app_navigator.dart';

import '../../../features/login/repositories/login_repository.dart';

class BlocModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt
          ..registerLazySingleton(
            () => NetworkBloc(connectivity: Connectivity()),
          )
          ..registerLazySingleton(
            () => ConnectMediaBloc(),
          )
          ..registerLazySingleton(
            () => EmailBloc(),
          )
          ..registerLazySingleton(
            () => QrFeedBloc(),
          )
          ..registerLazySingleton(
            () => VietQRStoreBloc(),
          )
          ..registerLazySingleton(
            // (param1, param2) => BankBloc(param1 as BuildContext),
            () => BankBloc(NavigationService.context!),
          )
          ..registerLazySingleton(
            () => NewTransactionBloc(),
          )
          ..registerLazySingleton(
            () => DashBoardBloc(
              NavigationService.context!,
              getIt.get<LoginRepository>(),
            ),
          )
          ..registerLazySingleton(
            () => RegisterBloc(getIt.get<RegisterRepository>()),
          )
          ..registerFactoryParam(
            (param1, param2) =>
                BankCardBloc(param1 as String, isLoading: param2 as bool),
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
              getIt.get<LoginRepository>(),
            ),
          )
        // ..registerFactoryParam(
        //   (param1, param2) => RegisterBloc(
        //     getIt.get<RegisterRepository>(),
        //   ),
        // );
        ;
  }
}
