import 'package:flutter/material.dart';

class ColorTransitionContainer extends StatefulWidget {
  const ColorTransitionContainer({super.key});

  @override
  _ColorTransitionContainerState createState() =>
      _ColorTransitionContainerState();
}

class _ColorTransitionContainerState extends State<ColorTransitionContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // boucle infinie avec va-et-vient

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // nettoyage
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        ),
      ),
    );
  }
}
