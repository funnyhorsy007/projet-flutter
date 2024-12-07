import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:younesse/services/model_service.dart';

class Ann extends StatefulWidget {
  @override
  _AnnState createState() => _AnnState();
}

class _AnnState extends State<Ann> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _result;
  final ModelService _modelService = ModelService();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _modelService.loadModel();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _predictImage(pickedFile.path);
    }
  }

  Future<void> _predictImage(String imagePath) async {
    var predictions = await _modelService.predict(imagePath);
    if (predictions != null && predictions.isNotEmpty) {
      setState(() {
        _result = predictions[0]['label'];
      });
    } else {
      setState(() {
        _result = "Aucun résultat trouvé.";
      });
    }
  }

  @override
  void dispose() {
    _modelService.disposeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classification d'Image"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Text("Aucune image sélectionnée."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Téléverser une image"),
            ),
            SizedBox(height: 20),
            Text(
              _result ?? "Le résultat sera affiché ici.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
