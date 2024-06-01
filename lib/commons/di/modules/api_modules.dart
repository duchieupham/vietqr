import 'package:vierqr/commons/base/di_module.dart';

class ApiModule extends DIModule {
  @override
  Future<void> provides() async {
    // final dio = await DioClient.setup(getIt.get<DdvInterceptor>());
    //
    // getIt..registerLazySingleton<Dio>(() => dio);
  }
}
