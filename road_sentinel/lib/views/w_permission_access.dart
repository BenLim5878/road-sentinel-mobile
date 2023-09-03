import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:road_sentinel/utils/script.dart';
import 'package:permission_handler/permission_handler.dart'
    as DefaultPermissionHandler;
import 'package:location/location.dart' as FlutterLocation;
import '../main.dart';
import 'w_user_home.dart';

DefaultPermissionHandler.Permission getCameraPermission() {
  return DefaultPermissionHandler.Permission.camera;
}

Future<FlutterLocation.PermissionStatus> getLocationPermission() {
  return location.hasPermission();
}

class PermissionAccessWidget extends StatefulWidget {
  const PermissionAccessWidget({super.key});

  @override
  State<PermissionAccessWidget> createState() => _PermissionAccessWidgetState();
}

class _PermissionAccessWidgetState extends State<PermissionAccessWidget>
    with WidgetsBindingObserver {
  bool isCameraGranted = false;
  bool isLocationGranted = false;
  bool isCameraPermanentlyDenied = false;
  bool isLocationPermanentlyDenied = false;
  bool isCameraFirstRequest = true;
  bool isLocationFirstRequest = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissionStatus();
      getPostLocationPermission();
      getPostCameraPermission();
    });
  }

  void checkPermissionStatus() async {
    bool _isCameraGranted =
        await getCameraPermission().isGranted ? true : false;
    bool _isLocationGranted = await getLocationPermission() ==
            FlutterLocation.PermissionStatus.granted
        ? true
        : false;

    if (_isCameraGranted && _isLocationGranted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserHomeWidget()));
    }
  }

  Future<void> requestCameraPermission() async {
    if (isCameraPermanentlyDenied) {
      await DefaultPermissionHandler.openAppSettings();
      return;
    }

    var status = DefaultPermissionHandler.Permission.camera.request();
    if (await status.isPermanentlyDenied) {
      if (isCameraFirstRequest) {
        await DefaultPermissionHandler.openAppSettings();
      }
      isCameraPermanentlyDenied = true;
    }

    if (await status.isGranted) {
      setState(() {
        isCameraGranted = true;
      });
    }
    isCameraFirstRequest = false;
  }

  Future<void> requestLocationPermission() async {
    if (isLocationPermanentlyDenied) {
      await DefaultPermissionHandler.openAppSettings();
      return;
    }

    FlutterLocation.PermissionStatus permissionGranted =
        await location.requestPermission();
    if (permissionGranted == FlutterLocation.PermissionStatus.deniedForever) {
      if (isLocationFirstRequest) {
        await DefaultPermissionHandler.openAppSettings();
      }
      isLocationPermanentlyDenied = true;
    }

    if (permissionGranted == FlutterLocation.PermissionStatus.granted) {
      setState(() {
        isLocationGranted = true;
      });
    }
    isLocationFirstRequest = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getPostCameraPermission();
      getPostLocationPermission();
    }
  }

  getPostCameraPermission() async {
    bool _isCameraGranted =
        await getCameraPermission().isGranted ? true : false;
    setState(() {
      isCameraGranted = _isCameraGranted;
      if (_isCameraGranted) {
        isCameraPermanentlyDenied = false;
      }
    });
  }

  getPostLocationPermission() async {
    bool _isLocationGranted = await getLocationPermission() ==
            FlutterLocation.PermissionStatus.granted
        ? true
        : false;
    setState(() {
      isLocationGranted = _isLocationGranted;
      if (_isLocationGranted) {
        isLocationPermanentlyDenied = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: hexToColor("#17192D"),
        body: // Generated code for this Column Widget...
            Align(
          alignment: AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: MediaQuery.sizeOf(context).height * 0.9,
                decoration: BoxDecoration(
                  color: Color(0x00FFFFFF),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Container(
                          width: 60,
                          height: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/sentinel-view-logo.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1, 0),
                        child: Text(
                          'Before we start,',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'We need to request some access for the app to funtion properly.',
                        style: TextStyle(
                          color: Color(0xFFDADADA),
                          fontSize: 14.5,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: TextButton(
                          onPressed: () => {requestLocationPermission()},
                          style: TextButton.styleFrom(
                              backgroundColor: hexToColor("#17192D"),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10)),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: isLocationGranted
                                          ? hexToColor("#41CC86")
                                          : Colors.grey,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Location',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: Color(0x00FFFFFF),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Text(
                                              'To obtain real-time GPS coordinates for determining the location of potholes',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: isLocationGranted
                                                    ? Color(0xFF389CFE)
                                                    : Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        child: Divider(
                          color: Color(0x3CFFFFFF),
                        ),
                      ),
                      TextButton(
                        onPressed: () => {requestCameraPermission()},
                        style: TextButton.styleFrom(
                            backgroundColor: hexToColor("#17192D"),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    color: isCameraGranted
                                        ? hexToColor("#41CC86")
                                        : Colors.grey,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Camera',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      ClipRRect(
                                        child: Container(
                                          width: 271,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: Color(0x00FFFFFF),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: AutoSizeText(
                                              'To capture road image and send the image to the server',
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: isCameraGranted
                                                    ? Color(0xFF389CFE)
                                                    : Colors.blueGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                        child: ElevatedButton(
                          onPressed: isCameraGranted && isLocationGranted
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserHomeWidget()));
                                }
                              : null,
                          child: Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(223, 65, 219, 134),
                            disabledBackgroundColor: Colors.grey,
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }
}
