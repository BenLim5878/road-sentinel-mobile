import 'package:road_sentinel/views/w_user_home.dart';

import 'views/w_login.dart';
import 'views/w_get_started.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:location/location.dart';
// Testing
import './views/w_permission_access.dart';

var location = new Location();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstLaunch = await IsFirstRun.isFirstRun();
  runApp(PreLoginPage(isFirstLaunch));
}

class PreLoginPage extends StatelessWidget {
  final bool isFirstLaunch;
  PreLoginPage(this.isFirstLaunch);
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: PermissionAccessWidget());
    return MaterialApp(
        home: isFirstLaunch
            ? SwipeScreen(isFirstLaunch: isFirstLaunch)
            : LoginWidget(
                isFirstLaunch: isFirstLaunch,
              ));
  }
}

class PreLoginPageUtil {
  static PageController _pageController = PageController(initialPage: 0);

  static void navigateToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  static void navigateToPreviousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class SwipeScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const SwipeScreen({Key? key, required this.isFirstLaunch}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PreLoginPageUtil._pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          GetStartedWidget(),
          LoginWidget(isFirstLaunch: widget.isFirstLaunch),
        ],
      ),
    );
  }

  @override
  void dispose() {
    PreLoginPageUtil._pageController.dispose();
    super.dispose();
  }
}
