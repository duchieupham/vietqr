import 'package:get_it/get_it.dart';
import 'package:vierqr/commons/di/modules/api_modules.dart';
import 'package:vierqr/commons/di/modules/bloc_modules.dart';

GetIt getIt = GetIt.instance;

class Injection {
  static Future<void> inject() async {
    // await CommonModule().provides();
    // await ComponentsModule().provides();
    await ApiModule().provides();
    // await LocalDataSourceModule().provides();
    // await ServicesModule().provides();
    // await RepositoryModule().provides();
    await BlocModule().provides();
  }
}
