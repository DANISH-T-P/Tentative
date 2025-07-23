import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/message_model.dart';

class SocketService extends GetxService {
  late IO.Socket _socket;
  final String username;

  SocketService(this.username);

  Future<void> connect() async {
    // _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{ // use this line for Web run.
    _socket = IO.io("http://192.168.1.10:3000", <String, dynamic>{ // use this line for mobile run.
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.onConnect((_) {
      print('Connected as $username');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  void onUserJoined(Function(String) callback) {
    _socket.on('user_joined', (username) {
      print("$username joined");
    });
  }

  void onUserLeft(Function(String) callback) {
    _socket.on('user_left', (username) {
      print("$username left");
    });
  }


  void sendChatMessage(Message message) {
    _socket.emit('chat', message.toJson());
  }

  void onChatReceived(Function(Map<String, dynamic>) callback) {
    _socket.on('chat', (data) {
      if (data is Map<String, dynamic>) {
        callback(data);
      } else if (data is String) {
        try {
          final parsed = Map<String, dynamic>.from(data as Map);
          callback(parsed);
        } catch (_) {
          print("Invalid chat data format");
        }
      }
    });
  }

  void sendScrollPosition(double offset) {
    _socket.emit('scroll', offset);
  }

  void onScrollReceived(Function(double offset) callback) {
    _socket.on('scroll', (data) {
      if (data is double) {
        callback(data);
      } else if (data is int) {
        callback(data.toDouble());
      } else if (data is String) {
        try {
          callback(double.parse(data));
        } catch (e) {
          print("Invalid scroll offset format: $data");
        }
      }
    });
  }

  void sendTyping(String username) {
    _socket.emit('typing', username);
  }

  void sendStopTyping(String username) {
    _socket.emit('stop_typing', username);
  }

  void onTyping(Function(String) callback) {
    _socket.on('typing', (data) {
      if (data is String) callback(data);
    });
  }

  void onStopTyping(Function(String) callback) {
    _socket.on('stop_typing', (data) {
      if (data is String) callback(data);
    });
  }

  void sendBroadcast(String message) {
    _socket.emit('broadcast', message);
  }

  void onBroadcast(Function(String) callback) {
    _socket.on('broadcast', (msg) {
      if (msg is String) callback(msg);
    });
  }

  void disposeSocket() {
    _socket.dispose();
  }
}
