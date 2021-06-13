/* 
  This service keeps on checking the status of user's device's internet
  connection to build network-sensitive UI for several interactions
*/
import 'dart:async';

import '../utils/index.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionService {
  StreamController<ConnectionStatus> connectioncontroller =
      StreamController<ConnectionStatus>();

  ConnectionService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult res) {
      // Convert ConnectivityResult to ConnectionStatus

      final _status = getStatus(res);

      // Broadcast over stream
      connectioncontroller.add(_status);
    });
  }

  ConnectionStatus getStatus(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {

      // User is using mobile data
      case ConnectivityResult.mobile:
        return ConnectionStatus.Cellular;
        break;

      // User is using Wifi
      case ConnectivityResult.wifi:
        return ConnectionStatus.WiFi;
        break;

      // No internet connection is available
      case ConnectivityResult.none:
        return ConnectionStatus.Offline;
        break;

      default:
        return ConnectionStatus.Offline;
    }
  }
}
