import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:road_sentinel/backends/auth.dart';
import 'package:road_sentinel/views/w_get_started.dart';
import 'package:road_sentinel/views/w_permission_access.dart';
import 'package:road_sentinel/views/w_user_home.dart';
import './w_animated_hero.dart';
import '../utils/script.dart';
import '../main.dart';
import './w_screen_loader.dart';
import '../backends/auth.dart';

class LoginWidget extends StatefulWidget {
  final bool isFirstLaunch;
  final bool isInvalidCredentials;
  final bool isInvalidConnection;

  const LoginWidget(
      {Key? key,
      required this.isFirstLaunch,
      this.isInvalidCredentials = false,
      this.isInvalidConnection = false})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidget();
}

class _LoginWidget extends State<LoginWidget> {
  bool passwordIsVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkSession();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.isInvalidConnection) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to establish connection, please try later.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (widget.isInvalidCredentials) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credentials, please try again!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  checkSession() async {
    bool isValid = await checkSessionToken();
    if (isValid) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => PermissionAccessWidget()));
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordIsVisible = !passwordIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: hexToColor('#17192D'),
        extendBodyBehindAppBar: true,
        appBar: widget.isFirstLaunch
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    PreLoginPageUtil.navigateToPreviousPage();
                    FocusScope.of(context).unfocus();
                  },
                ),
              )
            : null,
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
                    AnimatedHeroWidget(),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: AutoSizeText(
                        'Log In',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 5),
                      child: AutoSizeText(
                        'Please sign in to continue.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 184, 184, 184),
                            fontSize: 17,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Container(
                                child: TextFormField(
                              autofocus: false,
                              obscureText: false,
                              controller: emailController,
                              autofillHints: [AutofillHints.email],
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: const TextStyle(
                                    color: Color(0xFFA3A3A3), fontSize: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(0, 182, 180, 180),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(96, 0, 226, 151),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(103, 41, 41, 41),
                                prefixIcon: const Icon(
                                  Icons.email_rounded,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  size: 20,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 0, 0),
                            child: Container(
                                child: TextFormField(
                              // controller: _model.textController,
                              autofocus: false,
                              obscureText: !passwordIsVisible,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    color: Color(0xFFA3A3A3), fontSize: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(0, 182, 180, 180),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(96, 0, 226, 151),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(103, 41, 41, 41),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  size: 20,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => {togglePasswordVisibility()},
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    passwordIsVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: passwordIsVisible
                                        ? Color.fromARGB(169, 0, 255, 145)
                                        : Color.fromARGB(255, 139, 139, 139),
                                    size: 18,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 30, 0, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FutureBuilder<Map<String, dynamic>>(
                                            future: authUser(
                                                emailController.text,
                                                passwordController.text),
                                            builder: ((context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return ScreenLoaderWidget();
                                              } else {
                                                if (snapshot.data?["status"] ==
                                                    true) {
                                                  return PermissionAccessWidget();
                                                } else {
                                                  return LoginWidget(
                                                      isFirstLaunch: false,
                                                      isInvalidCredentials:
                                                          true);
                                                }
                                              }
                                            }),
                                          )),
                                );
                              },
                              child: Text('Login'),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: hexToColor("#41CC86")),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            )));
  }
}
