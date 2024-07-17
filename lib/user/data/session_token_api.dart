import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/core/network/network_module.dart';
import 'package:movie_app/user/data/session.dart';
import 'package:movie_app/user/data/session_request.dart';

@lazySingleton
class SessionTokenApi {
  final Dio dio;
  // final NetworkModule networkModule;
  SessionTokenApi(this.dio);

  Future<SessionReqeust> newSession(final SessionLoad load) async {
    try {
      final response =
          await dio.post('/authentication/session/new', data: load.toJson());
      return SessionReqeust.fromJson(response.data);
    } on DioError catch (ex) {
      if (ex.response?.statusCode == 401 || ex.response?.statusCode == 404) {
        throw ex.response?.data['status_message'];
      }
      rethrow;
    }
  }
}
final sessionTokenApiProvider = Provider((ref) => SessionTokenApi(ref.watch(dioProvider)));
