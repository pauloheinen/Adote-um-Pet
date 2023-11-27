import 'package:adote_um_pet/android/entities/user.entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketManager {
  late IO.Socket socket;
  late Function(dynamic message)? onReceiveMessage;

  static final WebSocketManager _instance = WebSocketManager._internal();

  static WebSocketManager get instance => _instance;

  WebSocketManager._internal();

  factory WebSocketManager() {
    return _instance;
  }

  Future<void> initSocket(User user,
      {Function(dynamic message)? onReceiveMessage}) async {
    await dotenv.load(fileName: "env.env");

    socket = IO.io(dotenv.get('websocketUrl'), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    Map<String, dynamic> userData = user.toJson();

    socket.connect();
    socket.onConnect((_) {
      userData['socketId'] = socket.id;
      socket.emit("connectUser", {"type": "connect", "user": userData});
      print('connected to websocket');
    });
    socket.onError((error) {
      print('Socket error: $error');
    });
    socket.onConnectError((data) => print("error on connect $data"));

    socket.on('chat', (msg) {
      if (onReceiveMessage != null) {
        print("mensagem recebida na conversations");
        onReceiveMessage(msg);
      }
    });
  }

  void sendMessage(dynamic data) {
    if (socket.connected) {
      print("sera enviado uma mensagem ");

      socket.emit('chat', data);
    }
  }

  bool isConnected() {
    return socket.connected;
  }

  void disconnectSocket() {
    if (socket.connected) {
      print("socket desconectado");

      socket.disconnect();
    }
  }
}
