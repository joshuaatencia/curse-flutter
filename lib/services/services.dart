import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Connecting, Offline }

class Services with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  Services() {
    _initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => _socket;

  void _initConfig() {
    _socket = IO.io('http://192.168.1.55:8000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // _socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje: $payload');
    //   print('nombre: ' + payload['nombre']);
    //   print('mensaje: ' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    // });
  }
}
