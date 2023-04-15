import 'package:dio/dio.dart';
import 'package:practical_demo/api_helper/api_services.dart';

class Apis
{
  static const baseUrl  = "http://205.134.254.135/";
  static const itemList = "~mobile/MtProject/public/api/product_list.php";

  /// Fetch Items
  Future fetchItems(Map<String,dynamic> data)
  async
  {
    Response response = await ApiService().post(itemList , params: data);
    return response;
  }
}