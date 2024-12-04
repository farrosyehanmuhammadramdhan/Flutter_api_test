// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String name = '';
  String description = '';
  String price = '';
  String imageurl = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => name = value,
              decoration: InputDecoration(labelText: 'Name Product'),
            ),
            SizedBox(height: 6),
            TextField(
              onChanged: (value) => description = value,
              decoration: InputDecoration(labelText: 'Description Product'),
            ),
            SizedBox(height: 6),
            TextField(
              onChanged: (value) => price ,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 6),
            TextField(
              onChanged: (value) => imageurl = value,
              decoration: InputDecoration(labelText: 'Image Product'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: addProduct, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue
              ),
              child: Text(
                'Add Product',
                style: TextStyle(color: Colors.white),
              )
            )
          ],
        ),
      ),
    );
  }

  Future<void> addProduct() async {
    setState(() => isLoading = true);

    try {
      var response = await http
          .post(Uri.parse('https://fakestoreapi.com/products/'), body: {
        'name': name,
        'description': description,
        'image': imageurl,
        'price': price
      });

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product Added: ${jsonResponse.body}')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to Add Product: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error occured: $e')));
    }

    setState(() => isLoading = false);
  }
}
