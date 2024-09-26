import 'package:dio/dio.dart';
import 'package:vierqr/commons/base/di_module.dart';

import '../../../data/remotes/auth_api.dart';
import '../../constants/env/env_config.dart';
import '../../network/dio_client.dart';
import '../../network/interceptor/vietqr_interceptor.dart';
import '../injection/injection.dart';

class ApiModule extends DIModule {
  @override
  Future<void> provides() async {
    AppConfig appConfig = getIt.get<AppConfig>();
    await appConfig.loadEnvConfig();

    final dio =
        await DioClient.setup(getIt.get<VietQRInterceptor>(), appConfig);

    getIt
      ..registerLazySingleton<Dio>(() => dio)
      ..registerLazySingleton(
        () => AuthApi(getIt.get<Dio>()),
      );
  }
}
