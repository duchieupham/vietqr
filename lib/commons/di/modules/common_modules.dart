import 'package:vierqr/commons/base/di_module.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';

class CommonModule extends DIModule {
  @override
  Future<void> provides() async {
    getIt..registerLazySingleton(() => AppConfig());
  }
}
