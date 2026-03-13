import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'category_selection_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  final ApiService apiService;

  const ModeSelectionScreen({Key? key, required this.apiService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Modu Seçin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () => _selectMode(context, 'KURULUM'),
              child: const Text('KURULUM', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () => _selectMode(context, 'ARIZA'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('ARIZA', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _selectMode(BuildContext context, String mode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          apiService: apiService,
          mode: mode,
        ),
      ),
    );
  }
}
