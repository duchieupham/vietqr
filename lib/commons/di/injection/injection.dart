import 'package:get_it/get_it.dart';
import 'package:vierqr/commons/di/modules/api_modules.dart';
import 'package:vierqr/commons/di/modules/bloc_modules.dart';
import 'package:vierqr/commons/di/modules/common_modules.dart';
import 'package:vierqr/commons/di/modules/repository_modules.dart';

import '../../enums/env_type.dart';

GetIt getIt = GetIt.instance;

class Injection {
  static Future<void> inject({EnvType? env}) async {
    await CommonModule().provides(env: env ?? EnvType.PROD);
    // await ComponentsModule().provides();
    await ApiModule().provides();
    // await LocalDataSourceModule().provides();
    // await ServicesModule().provides();
    await RepositoryModule().provides();
    await BlocModule().provides();
  }
}
