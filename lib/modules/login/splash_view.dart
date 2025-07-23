import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../modules/login/user_controller.dart';
import '../../services/socket_service.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  final UserController userController = Get.find();

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  bool showSubtitle = false;

  @override
  void initState() {
    super.initState();

    // Logo Animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    _logoController.forward();

    // Logo
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      showSubtitle = true;
    });

    // subtitle
    await Future.delayed(Duration(milliseconds: 3000));

    // Navigate
    if (userController.isLoggedIn) {
      final socketService = SocketService(userController.username.value);
      await socketService.connect();
      Get.put<SocketService>(socketService);
      Get.offAllNamed('/catalog');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Text(
                "Tentative",
                style: textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (showSubtitle)
              DefaultTextStyle(
                style: textTheme.bodySmall!.copyWith(
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Real-Time Product Catalog Sharing App',
                      speed: Duration(milliseconds: 50),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
