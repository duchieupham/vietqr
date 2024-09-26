import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/http.dart';

import '../../commons/enums/authentication_type.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('accounts')
  Future<dynamic> login(
    @Header('type') AuthenticationType type,
    @Body() Map<String, dynamic> data,
  );

  @POST('accounts/password/reset')
  Future<dynamic> resetPassword(
    @Header('type') AuthenticationType type,
    @Body() Map<String, dynamic> data,
  );

  @GET('token_generate')
  Future<dynamic> genFreeToken({
    @Header('type') required AuthenticationType type,
    @Header('bearerToken') required String bearerToken,
  });

  @GET('accounts/search/{phone}')
  Future<dynamic> checkPhoneExist({
    @Header('type') required AuthenticationType type,
    @Path() required String phone,
  });
}
