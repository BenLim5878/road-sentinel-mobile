import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/script.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenLoaderWidget extends StatefulWidget {
  const ScreenLoaderWidget({super.key});

  @override
  State<ScreenLoaderWidget> createState() => _ScreenLoaderWidgetState();
}

class _ScreenLoaderWidgetState extends State<ScreenLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 10.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: hexToColor("#17192D"),
            body: Center(
                child: Container(
              child: Container(
                child: SvgPicture.asset('assets/images/sentinel-view-logo.svg'),
                width: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      color: const Color.fromARGB(90, 255, 255, 255),
                      spreadRadius: _animation.value),
                ]),
              ),
            ))),
        onWillPop: () async {
          return false;
        });
  }
}
