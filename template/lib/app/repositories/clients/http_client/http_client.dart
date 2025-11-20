import 'package:dio/dio.dart';
import 'package:{{PROJECT_NAME}}/app/enums/http_call.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/client_response.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:{{PROJECT_NAME}}/app/services/auth/auth_cubit.dart';
import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';
import 'package:provider/provider.dart';

class HttpClient {
  final Dio dio;

  HttpClient(this.dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<ClientResponse<T>> call<T, R>(
    String endpoint, {
    HttpCall method = HttpCall.GET,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool tokenRequired = true,
  }) async {
    bool error = false;
    String? errorMessage;
    T? dataResult;

    try {
      dynamic response = await _getResponseFromAPI(
        endpoint,
        method,
        data,
        queryParameters,
        tokenRequired,
      );
      if (response is Map<String, dynamic>) {
        dataResult = _getResultObject<R>(response) as T;
      } else if (response is List) {
        dataResult = response.map((e) => _getResultObject<R>(e)).toList() as T;
      } else {
        dataResult = response as T;
      }
    } on DioException catch (dioException) {
      error = true;
      errorMessage = dioException.message;
    } on Exception catch (_) {
      error = true;
    }

    return ClientResponse<T>(
      data: dataResult,
      errorMessage: errorMessage,
      isError: error,
    );
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['tokenRequired'] ?? false) {
      String token = globalContext.read<AuthCubit>().session?.accessToken ?? '';
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    String message = error.response?.data['message'] ?? translate.serverError;
    showSnackBar(message);
    handler.next(error);
  }

  Future<dynamic> _getResponseFromAPI(
    String endpoint,
    HttpCall method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool tokenRequired,
  ) async {
    switch (method) {
      case HttpCall.GET:
        return (await dio.get(
          endpoint,
          queryParameters: queryParameters,
          options: Options(extra: {'tokenRequired': tokenRequired}),
        ))
            .data;
      case HttpCall.POST:
        return (await dio.post(
          endpoint,
          queryParameters: queryParameters,
          options: Options(extra: {'tokenRequired': tokenRequired}),
          data: data,
        ))
            .data;
      case HttpCall.PUT:
        return (await dio.put(
          endpoint,
          queryParameters: queryParameters,
          options: Options(extra: {'tokenRequired': tokenRequired}),
          data: data,
        ))
            .data;
    }
  }

  R _getResultObject<R>(dynamic response) {
    switch (R) {
      case AuthSession:
        return AuthSession.fromJson(response) as R;
      default:
        return response as R;
    }
  }
}
