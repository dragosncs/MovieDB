import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:movie_app/auth/data/get_request_token_api.dart';
import 'package:movie_app/auth/data/login_api.dart';
import 'package:movie_app/auth/data/login_payload.dart';
import 'package:movie_app/auth/data/token_request.dart';
import 'package:movie_app/core/network/network_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/storage/storage_module.dart';
import '../../user/data/session.dart';
import '../../user/data/session_token_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// part 'login_repository.g.dart';

//
@singleton
// @preResolve
class LoginRepository {
  final LoginApi loginApi;
  final GetRequestTokenApi getRequestTokenApi;
  final SessionTokenApi sessionTokenApi;
final SharedPreferences sharedPreferences;
  LoginRepository(this.loginApi,this.getRequestTokenApi, this.sessionTokenApi, this.sharedPreferences);

 //    extends LoginRepositoryBase with _$LoginRepository {
 //  LoginRepository._(
 // loginApi,
 // getRequestTokenApi,
 // sessionTokenApi,
 //     sharedPreferences,
 //  ) : super(
 //          loginApi,
 //          getRequestTokenApi,
 //          sessionTokenApi,
 //          sharedPreferences,
 //        );

      // : super(  loginApi,
  //             getRequestTokenApi,
  //             sessionTokenApi,
  //             sharedPreferences,);
  // @factoryMethod
  // static Future<LoginRepository> create(
  //   LoginApi loginApi,
  //   GetRequestTokenApi getRequestTokenApi,
  //   SessionTokenApi sessionTokenApi,
  //   SharedPreferences sharedPreferences,
  // ) async {
  //   final loginRepository = LoginRepository._(
  //     loginApi,
  //     getRequestTokenApi,
  //     sessionTokenApi,
  //     sharedPreferences,
  //   );
  //   await loginRepository.checkAuthentification();
  //   return loginRepository;
  // }


 String requestToken = 'requestToken';
 String requestToke1 = 'requestToken1';

 String expiresTokenAt = 'expiredTokenAt';
 String expiresTokenAt1 = 'expiredTokenAt1';

 String sesionToken = 'sesionToken';
 String sesionToken1 = 'sesionToken1';

 String sessionId = 'sessionId';
 String sessionId1 = 'sessionId1';

// abstract class LoginRepositoryBase with Store {
//   @observable
  late bool isLoggedIn = false;
//
//   final LoginApi loginApi;
//   final GetRequestTokenApi getRequestTokenApi;
//   final SessionTokenApi sessionTokenApi;
//
//   final SharedPreferences sharedPreferences;
//
//   LoginRepositoryBase(this.loginApi, this.getRequestTokenApi,
//       this.sessionTokenApi, this.sharedPreferences);

  Future<bool> login(String username, String password) async {
    try {
      final TokenRequest token = await getRequestTokenApi.getRequestToken();
      final sesionToken = await loginApi.login(LoginPayload(
          username: username, password: password, requestToken: token.value));
      final session = await sessionTokenApi
          .newSession(SessionLoad(requestToken: sesionToken.value));

      await sharedPreferences.setString(requestToken, token.value);
      await sharedPreferences.setString(
          expiresTokenAt, token.expiresAt.toIso8601String());
      await sharedPreferences.setString(sessionId, session.value);

      // await secureStorage.write(key: requestToke1, value: token.value);
      // await secureStorage.write(
      //     key: expiresTokenAt1, value: token.expiresAt.toIso8601String());
      // await secureStorage.write(key: sessionId1, value: session.value);

      checkAuthentification();
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> checkAuth1() async {
    final String? token = sharedPreferences.getString(requestToken);
    print(token);

    if (token == null) return false;

    final String? tokenExpiredString =
        sharedPreferences.getString(expiresTokenAt);

    if (tokenExpiredString == null) return false;

    final DateTime tokenExpiredDate = DateTime.parse(tokenExpiredString);
    final DateTime now = DateTime.now().toUtc();

    final Duration diff = tokenExpiredDate.difference(now);

    if (diff.inMilliseconds <= 0) {
      return false;
    }
    return true;
  }

  // Future<bool> checkAuth2() async {
  //   final String? token2 = await secureStorage.read(key: requestToke1);

  //   if (token2 == null) return false;

  //   final String? tokenExpString =
  //       await secureStorage.read(key: expiresTokenAt1);

  //   if (tokenExpString == null) return false;

  //   final DateTime tokenExpDate1 = DateTime.parse(tokenExpString);
  //   final DateTime now1 = DateTime.now().toUtc();

  //   final Duration difference = tokenExpDate1.difference(now1);

  //   if (difference.inMilliseconds <= 0) {
  //     return false;
  //   }
  //   // isLoginWithSecure = true;
  //   return true;
  // }

  Future<void> clearToken() async {
    sharedPreferences.remove(requestToken);
    sharedPreferences.remove(expiresTokenAt);
    // secureStorage.delete(key: requestToke1);
    // secureStorage.delete(key: expiresTokenAt1);
  }

  Future<void> checkAuthentification() async {
    final bool hasToken = await checkAuth1();
    // final bool isLoggedInSecured = await checkAuth2();
    if (hasToken) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
      clearToken();
    }
  }

}
// final loginRepositoryProvider = Provider((ref) => LoginRepository(ref.watch(loginApiProvider),ref.watch(getRequestTokeApiProvider),ref.watch(sessionTokenApiProvider), ref.watch(sharePreferncesProvider)));
