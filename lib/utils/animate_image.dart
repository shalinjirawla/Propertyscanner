/**
 * Created by Jaimin on 05/06/24.
 */
import 'dart:math';

import 'package:flutter/material.dart';

class AnimateImage extends StatefulWidget {
  String? imageUrl;
  double? scale;

  AnimateImage({
    super.key,
    this.imageUrl,
    this.scale,
  });

  @override
  State<AnimateImage> createState() => _AnimateImageState();
}

class _AnimateImageState extends State<AnimateImage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.75, end: 2.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      ),
      child: Image.asset(
        widget.imageUrl!,
        scale: widget.scale!,
      ),
    );
  }
}

class RotateImageAnimation extends StatefulWidget {
  String? imageUrl;
  double? scale;

  RotateImageAnimation({
    super.key,
    this.imageUrl,
    this.scale,
  });

  @override
  _RotateImageAnimationState createState() => _RotateImageAnimationState();
}

class _RotateImageAnimationState extends State<RotateImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: Image.asset(
        widget.imageUrl!,
        scale: widget.scale!,
      ),
    );
  }
}

class ShakeImageAnimation extends StatefulWidget {
  String? imageUrl;
  double? scale;

  ShakeImageAnimation({
    super.key,
    this.imageUrl,
    this.scale,
  });

  @override
  State<ShakeImageAnimation> createState() => _ShakeImageAnimationState();
}

class _ShakeImageAnimationState extends State<ShakeImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final dx = sin(_controller.value * 2 * pi) * 10.0;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: Image.asset(
        widget.imageUrl!,
        scale: widget.scale!,
      ),
    );
  }
}

class ShakeUpImageAnimation extends StatefulWidget {
  String? imageUrl;
  double? scale;

  ShakeUpImageAnimation({
    super.key,
    this.imageUrl,
    this.scale,
  });

  @override
  State<ShakeUpImageAnimation> createState() => _ShakeUpImageAnimationState();
}

class _ShakeUpImageAnimationState extends State<ShakeUpImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final dx = sin(_controller.value * 2 * pi) * 5.0;
        return Transform.translate(
          offset: Offset(0, dx),
          child: child,
        );
      },
      child: Image.asset(
        widget.imageUrl!,
        scale: widget.scale!,
      ),
    );
  }
}
