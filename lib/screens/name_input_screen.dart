import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'file_upload_screen.dart';

class NameInputScreen extends StatefulWidget {
  final ApiService apiService;
  final String mode;
  final String category;

  const NameInputScreen({
    Key? key,
    required this.apiService,
    required this.mode,
    required this.category,
  }) : super(key: key);

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final productInfoController = TextEditingController();
  bool isLoading = false;

  Future<void> confirmName() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        productInfoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tüm alanları doldurun')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final basePath = widget.mode == 'KURULUM'
          ? 'D:\\kopyalama\\kurulum'
          : 'D:\\kopyalama\\ariza';

      final fullName =
          '${firstNameController.text} ${lastNameController.text} - ${productInfoController.text}';

      // Create category folder
      await widget.apiService.createFolder(widget.category, basePath);

      // Create name folder
      final categoryPath = '$basePath\\${widget.category}';
      await widget.apiService.createFolder(fullName, categoryPath);

      final uploadPath = '$categoryPath\\$fullName';

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FileUploadScreen(
              apiService: widget.apiService,
              uploadPath: uploadPath,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bilgi Girin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'İsim',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Soyisim',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: productInfoController,
              decoration: const InputDecoration(
                labelText: 'Ürün Bilgisi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : confirmName,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Onayla'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    productInfoController.dispose();
    super.dispose();
  }
}
