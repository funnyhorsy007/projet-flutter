import 'package:tflite/tflite.dart';

class ModelService {
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model:
          "assets/model.tflite",
      labels: "assets/label.txt",
    );
  }

  Future<List?> predict(String imagePath) async {
    var predictions = await Tflite.runModelOnImage(
      path: imagePath,
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
