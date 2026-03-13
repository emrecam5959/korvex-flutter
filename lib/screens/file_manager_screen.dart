import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'mode_selection_screen.dart';

class FileManagerScreen extends StatefulWidget {
  final ApiService apiService;

  const FileManagerScreen({Key? key, required this.apiService})
      : super(key: key);

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Korvex File Manager')),
      body: ModeSelectionScreen(apiService: widget.apiService),
    );
  }
}
