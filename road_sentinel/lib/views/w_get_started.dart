import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../main.dart';
import '../utils/script.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedWidget extends StatelessWidget {
  const GetStartedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1,
            decoration: BoxDecoration(
              color: hexToColor("#17192D"),
            ),
            alignment: const AlignmentDirectional(0, 0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        height: MediaQuery.sizeOf(context).width * 0.15,
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
                    const AutoSizeText(
                      "Let's get started.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 15),
                      child: Center(
                        child: Image.asset(
                          'assets/images/get-started-illustration.png',
                          width: 350,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 70),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "Contribute to the community by navigating roads filled with potholes. ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Color.fromARGB(255, 184, 184, 184),
                              fontSize: 17,
                              height: 1.6,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {PreLoginPageUtil.navigateToNextPage()},
                      child: Text('Next'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: hexToColor("#1D99ED")),
                    ),
                  ]),
            )));
  }
}
