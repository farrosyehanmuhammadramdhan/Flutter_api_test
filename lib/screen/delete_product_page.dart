import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteProductPage extends StatefulWidget {
  const DeleteProductPage({super.key});

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  final TextEditingController idController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Product ID'),
            ),
            const SizedBox(height: 20),
            isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                onPressed: deleteProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ), 
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> deleteProduct() async {
    setState(() => isLoading = true);

    try {
      final response = await http.delete(
        Uri.parse('https://fakestoreapi.com/products/${idController.text}'),
      );

      final message = response.statusCode == 204
          ? 'Product deleted successfully'
          : 'Failed to delete product';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => isLoading = false);
  }
}
