import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    // Start animations after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _logoController.forward();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _textController.forward();
          }
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _progressController.forward();
          }
        });

        // Navigate to main page after splash animations complete
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _launchShannan() async {
    final Uri url = Uri.parse('https://salthaqafy.com/privacy-policy-2/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      // MADE RESPONSIVE - Logo scales to 40% of screen width for tablets
                      final logoSize = MediaQuery.of(context).size.width * 0.4;
                      final clampedSize = logoSize.clamp(
                        150.0,
                        300.0,
                      ); // Min 150, Max 300

                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Image.asset(
                          'assets/logo.png',
                          width: clampedSize,
                          height: clampedSize,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textAnimation.value,
                        child: Text(
                          'كتب الدكتور سالم الثقفي',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: _progressAnimation.value,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          strokeWidth: 4,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: _launchShannan,
              child: Text(
                'جميع الحقوق محفوظة لدي موقع كتب دكتور سالم الثقفي',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppIconLoader extends StatefulWidget {
  const AppIconLoader({super.key});

  @override
  _AppIconLoaderState createState() => _AppIconLoaderState();
}

class _AppIconLoaderState extends State<AppIconLoader>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Error: $errorMessage')));
  }
}
