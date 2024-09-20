import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHelper {
  ConnectionHelper._();
  // Private Helper Methods

  static Future<bool> hasNoConnectivity() async {
    return (await Connectivity().checkConnectivity()) == ConnectivityResult.none;
  }

}