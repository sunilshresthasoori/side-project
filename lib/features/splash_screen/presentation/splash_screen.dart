import 'package:flutter/material.dart';
import 'package:trekkers_odyssey_v2/app/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotateAnimation = Tween<double>(
      begin: 0.2, // Tilted
      end: 0.0, // Straight
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _controller.forward();
    
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home'); 
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.saffronAccent),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon styling enhanced
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.glacierWhite.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.landscape_rounded,
                    size: 32,
                    color: AppColors.glacierWhite,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Animated Text
                RotationTransition(
                  turns: _rotateAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TREKKERS",
                          style: AppTypography.headline(context).copyWith(
                            color: AppColors.glacierWhite.withAlpha(200),
                            letterSpacing: 4.0,
                            height: 1.0, 
                          ),
                        ),
                        Text(
                          "ODYSSEY",
                          style: AppTypography.display1(context).copyWith(
                            color: AppColors.glacierWhite,
                            letterSpacing: 0.5,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // GIF
                /*Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.glacierWhite.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Image.asset(
                    'assets/lottie/hiking.gif',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
