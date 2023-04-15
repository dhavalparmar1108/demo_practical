
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:practical_demo/utilities/common_functions.dart';

class CustomInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.uri} param ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('RESPONSE[${response.statusMessage}] => PATH: ${response.requestOptions.path}');
    print("- ${jsonEncode(response.data)}");
    return super.onResponse(response, handler);
  }

  @override
   onError(DioError err, ErrorInterceptorHandler handler) async{
    print('ERROR[${err.message.toString()}] => PATH: ${err.requestOptions.path} ${err.type} -- ${err.response.toString()} -- ${err.type}');
    return handler.resolve(err.response?? Response(data: jsonEncode(CommonFunctions.errorJson()) , requestOptions:  err.requestOptions));
  }
}
