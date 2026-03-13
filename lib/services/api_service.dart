import 'dart:convert';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  String host;
  int port;
  late String sessionId;
  WebSocketChannel? _webSocketChannel;

  ApiService({this.host = '10.0.2.2', this.port = 5556});

  Future<bool> authenticate(String password) async {
    try {
      final command = {
        'command': 'AUTH_INIT',
        'params': {'password': password}
      };

      final response = await _sendCommand(jsonEncode(command));
      final data = jsonDecode(response);

      if (data['status'] == 'success') {
        sessionId = data['sessionId'];
        return true;
      }
      return false;
    } catch (e) {
      print('Auth error: $e');
      return false;
    }
  }

  Future<bool> createFolder(String folderName, String parentPath) async {
    try {
      final command = {
        'command': 'CREATE_FOLDER',
        'sessionId': sessionId,
        'params': {
          'folderName': folderName,
          'parentPath': parentPath.replaceAll('\\', '\\\\')
        }
      };

      final response = await _sendCommand(jsonEncode(command));
      final data = jsonDecode(response);
      return data['status'] == 'success';
    } catch (e) {
      print('Create folder error: $e');
      return false;
    }
  }

  Future<bool> uploadFile(
      String fileName, String destinationPath, List<int> fileData) async {
    try {
      final encodedData = base64Encode(fileData);
      final command = {
        'command': 'UPLOAD_FILE',
        'sessionId': sessionId,
        'params': {
          'fileName': fileName,
          'destinationPath': destinationPath.replaceAll('\\', '\\\\'),
          'fileData': encodedData
        }
      };

      final response = await _sendCommand(jsonEncode(command));
      final data = jsonDecode(response);
      return data['status'] == 'success';
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }

  Future<String> _sendCommand(String command) async {
    try {
      if (_isWeb()) {
        return await _sendCommandWeb(command);
      } else {
        return await _sendCommandNative(command);
      }
    } catch (e) {
      throw Exception('Communication error: $e');
    }
  }

  bool _isWeb() {
    try {
      return identical(0, 0.0) == false;
    } catch (e) {
      return false;
    }
  }

  Future<String> _sendCommandWeb(String command) async {
    try {
      final wsUrl = 'ws://$host:$port';
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _webSocketChannel!.sink.add(command);
      final response = await _webSocketChannel!.stream.first;
      _webSocketChannel!.sink.close();

      return response.toString();
    } catch (e) {
      throw Exception('WebSocket error: $e');
    }
  }

  Future<String> _sendCommandNative(String command) async {
    try {
      // Socket import sadece native platformlarda kullanılabilir
      // Web platformunda bu kod çalışmaz
      throw Exception('Native socket not available on web platform');
    } catch (e) {
      throw Exception('Socket error: $e');
    }
  }
}
