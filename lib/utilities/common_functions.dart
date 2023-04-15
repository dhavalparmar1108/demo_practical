import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class CommonFunctions
{
  static showFlutterToast(String msg)
  {
    Fluttertoast.showToast(msg: msg);
  }

  Future<bool> checkConnection() async{
    ConnectivityResult connectivity = await Connectivity().checkConnectivity();

    if(connectivity == ConnectivityResult.wifi || connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.ethernet)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  Future initDb() async{
    Database cartDatabase = await openDb();
    await cartDatabase?.execute("CREATE TABLE IF NOT EXISTS cart(id INT , price INT , slug TEXT, title TEXT, description TEXT, created_at TEXT , featured_image TEXT , status TEXT , quantity INT)");
    return cartDatabase;
  }

  Future openDb() async {
    final db = await openDatabase(
      path.join(await getDatabasesPath(), 'cart.db'),
      version: 1,
    );
    return db;
  }

  static errorJson({String message = "Unknown error"})
  {
    Map<String , dynamic> x = {
      "error" : true , "message" : message
    };
    return x;
  }
}