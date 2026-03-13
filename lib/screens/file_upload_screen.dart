import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';

class FileUploadScreen extends StatefulWidget {
  final ApiService apiService;
  final String uploadPath;

  const FileUploadScreen({
    Key? key,
    required this.apiService,
    required this.uploadPath,
  }) : super(key: key);

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final List<XFile> selectedFiles = [];
  bool isUploading = false;
  int uploadedCount = 0;

  Future<void> selectFilesFromGallery() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    setState(() {
      selectedFiles.addAll(files);
    });
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        selectedFiles.add(photo);
      });
    }
  }

  Future<void> uploadFiles() async {
    if (selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dosya seçin')),
      );
      return;
    }

    setState(() {
      isUploading = true;
      uploadedCount = 0;
    });

    try {
      for (final file in selectedFiles) {
        final fileData = await File(file.path).readAsBytes();
        final success = await widget.apiService.uploadFile(
          file.name,
          widget.uploadPath,
          fileData,
        );

        if (success) {
          setState(() => uploadedCount++);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ $uploadedCount/${selectedFiles.length} dosya yüklendi'),
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
        setState(() => isUploading = false);
      }
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dosya Yükle')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Yol: ${widget.uploadPath}',
                style: const TextStyle(fontSize: 12)),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: selectFilesFromGallery,
                    child: const Text('GALERİ'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: takePhoto,
                    child: const Text('KAMERA'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(
                      File(selectedFiles[index].path),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => removeFile(index),
                        child: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isUploading ? null : uploadFiles,
                    child: isUploading
                        ? const CircularProgressIndicator()
                        : const Text('Yükle'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('ÇIK'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
