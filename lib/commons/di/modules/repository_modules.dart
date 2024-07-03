import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/data/remotes/auth_api.dart';
import 'package:vierqr/features/login/repositories/login_repository.dart';
import 'package:vierqr/features/transaction_detail/repositories/transaction_repository.dart';

class RepositoryModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt
      ..registerLazySingleton(
        () => TransactionRepository(
          getIt.get<AppConfig>(),
        ),
      )
      ..registerLazySingleton(
        () => LoginRepository(
          authApi: getIt.get<AuthApi>(),
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
