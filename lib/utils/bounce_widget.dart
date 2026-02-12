/**
 * Created by Jaimin on 12/06/24.
 */

import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;

  Bouncing({super.key, this.child, this.onTap});

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  double? _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (widget.onTap != null) {
          _controller.forward();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (widget.onTap != null) {
          _controller.reverse();
          widget.onTap!();
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

class BouncingItem extends StatefulWidget {
  final Widget child;
  final Function()? onTap;

  BouncingItem({
    required this.child,
    required this.onTap,
  });

  @override
  _BouncingItemState createState() => _BouncingItemState();
}

class _BouncingItemState extends State<BouncingItem> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(microseconds: 50),
        child: widget.child,
      ),
    );
  }
}
