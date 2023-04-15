
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

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
    try
    {
      Map<String , dynamic> customResponse = {
        "error" : true,
        "message" : "Error Occurred."
      };

      Response response = Response(data: customResponse, requestOptions: err.requestOptions);
      return handler.resolve(response!);
    }
    catch(e)
    {
      Map<String , dynamic> customResponse = {
        "error" : true,
        "message" : "Error Occurred."
      };

      Response response = Response(data: customResponse, requestOptions: err.requestOptions);
      return handler.resolve(response!);
    }
  }

}
