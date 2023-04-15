import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:practical_demo/api_helper/apis.dart';
import 'package:practical_demo/api_helper/interceptor.dart';
import 'package:practical_demo/constants/constants.dart';

class ApiService
{

  var options = BaseOptions(
    baseUrl:  Apis.baseUrl,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 10),
  );

  late Dio dio = Dio();

  ApiService()
  {
    dio.options = options;
    // dio.options.headers = {
    //   StringConstants.authToken : "Bearer ${StringConstants.token}"
    // };
    dio.interceptors.add(CustomInterceptors());
  }

  Future<Response> get(String route)
  async {

    Response response = await dio.get(route);
    return response;
  }

  Future<Response> post(String route ,
      {Map<String, dynamic>? data, Map<String, dynamic>? params ,bool fetchAccessToken = true})
  async {
    data = data ?? {};
    Response response = await dio.post(route , data: data , queryParameters: params);
    return response;
  }

  Future<Response> put(String route ,
      { Map<String, dynamic>? data , bool fetchAccessToken = true})
  async {

    Response response = await dio.put(route , data: data);
    return response;
  }

  Future<Response> delete(String route ,
      {bool fetchAccessToken = true , Map<String, dynamic>? data})
  async {
    Response response = await dio.delete(route , data: data);
    return response;
  }

}