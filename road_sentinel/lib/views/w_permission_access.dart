import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:road_sentinel/utils/script.dart';
import 'package:permission_handler/permission_handler.dart'
    as DefaultPermissionHandler;
import 'package:location/location.dart' as FlutterLocation;
import '../main.dart';

Future<void> requestCameraPermission() async {
  var status = await DefaultPermissionHandler.Permission.camera;

  if (await status.isPermanentlyDenied) {
    DefaultPermissionHandler.openAppSettings();
  } else if (await status.isGranted) {
    requestLocationPermission();
  } else if (await status.isDenied) {
    var permission = await DefaultPermissionHandler.Permission.camera.request();
    if (permission.isGranted) {
      requestLocationPermission();
    }
  }
}

Future<void> requestLocationPermission() async {
  final FlutterLocation.PermissionStatus permissionGranted =
      await location.hasPermission();
  if (permissionGranted == FlutterLocation.PermissionStatus.deniedForever) {
    DefaultPermissionHandler.openAppSettings();
  } else if (permissionGranted == FlutterLocation.PermissionStatus.denied) {
    FlutterLocation.PermissionStatus permission =
        await location.requestPermission();
    if (permission == FlutterLocation.PermissionStatus.granted) {
      // To do
    }
  }
}

class PermissionAccessWidget extends StatefulWidget {
  const PermissionAccessWidget({super.key});

  @override
  State<PermissionAccessWidget> createState() => _PermissionAccessWidgetState();
}

class _PermissionAccessWidgetState extends State<PermissionAccessWidget> {
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
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: hexToColor("#41CC86"),
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
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Text(
                                                'To obtain real-time GPS coordinates for determining the location of potholes',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Color(0xFF389CFE),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Divider(
                                              color: Color(0x3CFFFFFF),
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
                          height: 15,
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0),
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
                                      color: hexToColor("#41CC86"),
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
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(-1, 0),
                                              child: AutoSizeText(
                                                'To capture road image and send the image to the server',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Color(0xFF389CFE),
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
                            onPressed: () => {requestCameraPermission()},
                            child: Text('Allow all access'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: hexToColor("#41CC86")),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}
