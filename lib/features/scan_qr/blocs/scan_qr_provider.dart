import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/main.dart';

class ScanQrProvider extends ChangeNotifier {
  CameraController? controller;
  FlashMode? _currentFlashMode;
  bool isResetCamera = false;
  File? file;

  void updateFile(value) {
    file = value;
    controller = null;
    notifyListeners();
  }

  void updateResetCamera(value) {
    isResetCamera = value;
    if (value) {
      initializeCameraController(cameras[0]);
    }
    notifyListeners();
  }

  void initializeCameraController(CameraDescription cameraDescription) async {
    final cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    controller = cameraController;

    cameraController.addListener(() {
      notifyListeners();
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      LOG.error('Error initializing camera: $e');
    }

    _currentFlashMode = controller!.value.flashMode;

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
