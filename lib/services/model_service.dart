import 'package:tflite/tflite.dart';

class ModelService {
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model:
          "assets/model.tflite", // Assurez-vous d'ajouter le fichier dans le dossier assets.
      labels: "assets/label.txt", // Ajoutez également le fichier des labels.
    );
  }

  Future<List?> predict(String imagePath) async {
    var predictions = await Tflite.runModelOnImage(
      path: imagePath, // Chemin de l'image à analyser
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 10,
      threshold: 0.5,
    );
    return predictions;
  }

  Future<void> disposeModel() async {
    await Tflite.close();
  }
}
