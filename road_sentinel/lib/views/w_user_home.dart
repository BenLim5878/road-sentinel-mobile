import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:road_sentinel/utils/script.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:road_sentinel/views/w_permission_access.dart';

class UserHomeWidget extends StatefulWidget {
  const UserHomeWidget({super.key});

  @override
  State<UserHomeWidget> createState() => _UserHomeWidgetState();
}

class _UserHomeWidgetState extends State<UserHomeWidget> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCameraControllerFuture = _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // Request camera permissions
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController.initialize();
    } else {
      // Handle permission denied
      if (status.isPermanentlyDenied) {
        // Handle permanently denied permission
      } else {
        // Handle temporarily denied permission
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: PermissionAccessWidget(),
        onWillPop: () async {
          return false;
        });
  }
}
