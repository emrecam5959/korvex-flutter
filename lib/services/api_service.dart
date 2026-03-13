import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String host;
  final int port;
  late String sessionId;

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
      final socket = await Socket.connect(host, port,
          timeout: Duration(seconds: 10));
      socket.write('$command\n');
      await socket.flush();

      final response = await socket.first;
      socket.close();

      return utf8.decode(response).trim();
    } catch (e) {
      throw Exception('Socket error: $e');
    }
  }
}
