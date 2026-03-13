import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'name_input_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  final ApiService apiService;
  final String mode;

  const CategorySelectionScreen({
    Key? key,
    required this.apiService,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Seçin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryButton(context, 'TV'),
            const SizedBox(height: 16),
            _buildCategoryButton(context, 'SCOOTER'),
            const SizedBox(height: 16),
            _buildCategoryButton(context, 'Elektrikli Ev Aletleri'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _selectCategory(context, category),
        child: Text(category, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _selectCategory(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NameInputScreen(
          apiService: apiService,
          mode: mode,
          category: category,
        ),
      ),
    );
  }
}
