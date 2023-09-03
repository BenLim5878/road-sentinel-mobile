import 'package:flutter/material.dart';
import '../utils/script.dart';

class AppStatusIndicator extends StatefulWidget {
  const AppStatusIndicator({
    super.key,
  });

  @override
  State<AppStatusIndicator> createState() => _AppStatusIndicatorState();
}

class _AppStatusIndicatorState extends State<AppStatusIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle_rounded,
          size: 15,
          color: false ? hexToColor("00FFD0") : Colors.amber,
        ),
        SizedBox(
          width: 7,
        ),
        Text(
          'Disconnected',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
