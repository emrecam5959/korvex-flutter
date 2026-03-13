import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'file_manager_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final passwordController = TextEditingController();
  final hostController = TextEditingController(text: '10.0.2.2');
  final portController = TextEditingController(text: '5556');
  bool isLoading = false;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    
    // Web sürümü için varsayılan değerleri ayarla
    final isWeb = identical(0, 0.0) == false;
    if (isWeb) {
      hostController.text = 'localhost';
      portController.text = '5556';
    }
  }

  Future<void> authenticate() async {
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre girin')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      apiService = ApiService(
        host: hostController.text,
        port: int.parse(portController.text),
      );

      final success = await apiService.authenticate(passwordController.text);

      if (success) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FileManagerScreen(apiService: apiService),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kimlik doğrulama başarısız')),
          );
        }
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
      appBar: AppBar(title: const Text('Korvex - Kimlik Doğrulama')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: hostController,
              decoration: const InputDecoration(
                labelText: 'Host',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : authenticate,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Giriş Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    hostController.dispose();
    portController.dispose();
    super.dispose();
  }
}
