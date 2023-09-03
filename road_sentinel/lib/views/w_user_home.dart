import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:road_sentinel/utils/script.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:road_sentinel/views/w_login.dart';
import 'package:road_sentinel/views/w_permission_access.dart';
import 'package:road_sentinel/views/w_screen_loader.dart';
import '../main.dart';
import 'package:location/location.dart';
import '../backends/auth.dart';
import '../backends/upload.dart';
import 'package:image/image.dart' as img;
import 'package:wakelock/wakelock.dart';

class UserHomeWidget extends StatefulWidget {
  const UserHomeWidget({super.key});

  @override
  State<UserHomeWidget> createState() => _UserHomeWidgetState();
}

class UserHomeController {
  static PageController _pageController = PageController(initialPage: 0);

  static void navigateToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  static void navigateToPreviousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

class _UserHomeWidgetState extends State<UserHomeWidget>
    with WidgetsBindingObserver {
  bool isAppCapturing = false;
  bool isLocationOn = false;
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  AppStatus appStatus = AppStatus.LOCATION_UNAVAILABLE;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraControllerFuture = _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationService();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLocationService(false);
    } else if (state == AppLifecycleState.paused) {
      setState(() {
        isAppCapturing = false;
        disposeCamera();
        _timer.cancel();
        Wakelock.disable();
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);
    _cameraController.setFlashMode(FlashMode.off);
  }

  checkLocationService([bool request = true]) async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled && request) {
      requestLocationService();
    } else if (!serviceEnabled) {
      setState(() {
        isLocationOn = false;
        appStatus = AppStatus.LOCATION_UNAVAILABLE;
        isAppCapturing = false;
        disposeCamera(false);
        _timer.cancel();
        Wakelock.disable();
      });
    } else {
      setState(() {
        isLocationOn = true;
        if (appStatus == AppStatus.LOCATION_UNAVAILABLE) {
          appStatus = AppStatus.READY;
        }
      });
    }
  }

  Future<XFile?> checkAndRotateImage(XFile? imageFile) async {
    if (imageFile == null) return null;

    // Decode the image
    final Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    // Check for portrait mode
    // Rotate the image by 90 degrees
    img.Image rotatedImage = img.copyRotate(image!, angle: 0);

    // Convert the image back to an XFile
    final rotatedImageBytes = img.encodeJpg(rotatedImage);
    final rotatedImagePath =
        imageFile.path.replaceFirst('.jpg', '_rotated.jpg');
    await File(rotatedImagePath).writeAsBytes(rotatedImageBytes);

    return XFile(rotatedImagePath);
  }

  Future<XFile?> captureImage() async {
    if (_cameraController != null && _cameraController.value.isInitialized) {
      XFile? image = await this._cameraController.takePicture();
      image = await checkAndRotateImage(image);
      return image;
    }
  }

  capture() async {
    XFile? image = await captureImage();
    LocationData? locationData = await location.getLocation();
    if (image != null) {
      bool res = await uploadImage(
          image, locationData!.latitude, locationData!.longitude);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image uploaded successfully!"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  initCapturing() async {
    final res = await checkValidity();
    if (res["isValid"]) {
      Wakelock.enable();
      await initCamera();
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        capture();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"]),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isAppCapturing = false;
      });
    }
  }

  requestLocationService() async {
    var serviceEnabled = await location.requestService();
    if (serviceEnabled) {
      setState(() {
        isLocationOn = serviceEnabled;
        appStatus = AppStatus.READY;
      });
    }
  }

  initCamera() async {
    await _initializeCamera();
    await _cameraController.initialize();
    setState(() {
      appStatus = AppStatus.CONNECTED;
    });
  }

  disposeCamera([isReady = true]) {
    setState(() {
      if (isReady) {
        appStatus = AppStatus.READY;
      }
    });
    _cameraController.dispose();
  }

  logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => FutureBuilder<void>(
                future: logoutUser(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ScreenLoaderWidget();
                  } else {
                    return LoginWidget(isFirstLaunch: false);
                  }
                }),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: hexToColor("#17192D"),
            body: SafeArea(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        child: appStatus == AppStatus.CONNECTED
                            ? FutureBuilder<void>(
                                future: _initializeCameraControllerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return CameraPreview(_cameraController);
                                  } else {
                                    return ScreenLoaderWidget();
                                  }
                                })
                            : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/user-home-illustration.png',
                                        width: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: 300,
                                      child: Text(
                                        'Please switch on the app to start capturing road images...',
                                        style: TextStyle(
                                            color: Colors.white70, height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(15, 10, 5, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.92, -0.97),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: SvgPicture.asset(
                                            'assets/images/sentinel-view-logo.svg',
                                            fit: BoxFit.cover,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.circle_rounded,
                                            color: isLocationOn
                                                ? Color(0xBE00FF8F)
                                                : Colors.amber,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            isLocationOn
                                                ? 'Location Enabled'
                                                : 'Location Disabled',
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.93, -0.96),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Switch.adaptive(
                                      value: isAppCapturing,
                                      onChanged: appStatus == AppStatus.READY ||
                                              appStatus == AppStatus.CONNECTED
                                          ? (value) async {
                                              setState(() {
                                                isAppCapturing = value;
                                                if (value) {
                                                  initCapturing();
                                                } else {
                                                  _timer.cancel();
                                                  disposeCamera();
                                                  Wakelock.disable();
                                                }
                                              });
                                            }
                                          : null,
                                      activeColor: hexToColor("#3FFFD1"),
                                      inactiveTrackColor: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: hexToColor("#17192D"),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2))
                      ]),
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppIndicator(appStatus),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ElevatedButton(
                                onPressed: appStatus == AppStatus.CONNECTED
                                    ? null
                                    : () => logout(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    disabledBackgroundColor:
                                        Color.fromARGB(218, 172, 47, 38),
                                    disabledForegroundColor: Colors.grey),
                                child: Icon(
                                  Icons.logout,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                )
              ],
            ))),
        onWillPop: () async {
          return false;
        });
  }
}

Row AppIndicator(AppStatus appStatus) {
  Color iconColor = Colors.transparent;
  String labelText = "";

  switch (appStatus) {
    case AppStatus.LOCATION_UNAVAILABLE:
      iconColor = const Color.fromARGB(255, 119, 119, 119);
      labelText = "Location unavailable";
      break;
    case AppStatus.READY:
      iconColor = Colors.amber;
      labelText = "Ready";
      break;
    case AppStatus.CONNECTED:
      iconColor = hexToColor("#3FFFD1");
      labelText = "Connected";
      break;
  }

  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.circle_rounded, size: 15, color: iconColor),
      SizedBox(
        width: 7,
      ),
      Text(
        labelText,
        style: TextStyle(fontSize: 13, color: Colors.white),
      ),
    ],
  );
}

enum AppStatus { LOCATION_UNAVAILABLE, READY, CONNECTED }
