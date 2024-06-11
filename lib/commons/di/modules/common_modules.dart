import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/env_type.dart';

import '../../network/interceptor/vietqr_interceptor.dart';

class CommonModule extends DIModule {
  @override
  Future<void> provides({EnvType env = EnvType.PROD}) async {
    getIt
      ..registerLazySingleton(() => AppConfig()..setEnvConfig(env))
      ..registerLazySingleton(() => VietQRInterceptor());
  }
}
