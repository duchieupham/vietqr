import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/network/network_bloc.dart';

class BlocModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt
      ..registerLazySingleton(
        () => NetworkBloc(connectivity: Connectivity()),
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
