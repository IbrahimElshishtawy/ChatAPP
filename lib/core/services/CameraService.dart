import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras.first, ResolutionPreset.high);
    await _controller.initialize();
  }

  Future<void> captureImage() async {
    try {
      final image = await _controller.takePicture();
      print("Image captured: ${image.path}");
    } catch (e) {
      print("Error capturing image: $e");
    }
  }
}
