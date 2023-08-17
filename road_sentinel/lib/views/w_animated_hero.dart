import 'package:flutter/material.dart';

class AnimatedHeroWidget extends StatefulWidget {
  @override
  _AnimatedHeroState createState() => _AnimatedHeroState();
}

class _AnimatedHeroState extends State<AnimatedHeroWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation.value),
            child: Image.asset(
              'assets/images/login-illustration.png',
              width: 350,
            ),
          );
        },
      ),
    );
  }
}
