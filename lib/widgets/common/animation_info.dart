import 'package:flutter/material.dart';

enum AnimationType {
  translateY,
  translateX,
  translateXReverse,
  fadeIn,
  scale,
  rotate,
}

class AnimationInfo extends StatelessWidget {
  final Widget child;
  final int delay;
  final AnimationType animationType;

  AnimationInfo({
    required this.child,
    this.delay = 0,
    this.animationType = AnimationType.translateY,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Opacity(
            opacity: 0.0,
            child: child,
          );
        } else {
          switch (animationType) {
            case AnimationType.translateY:
              return _buildTranslateYAnimation();
            case AnimationType.translateX:
              return _buildTranslateXAnimation();
            case AnimationType.translateXReverse:
              return _buildTranslateXReverseAnimation();
            case AnimationType.fadeIn:
              return _buildFadeInAnimation();
            case AnimationType.scale:
              return _buildScaleAnimation();
            case AnimationType.rotate:
              return _buildRotateAnimation();
            default:
              return child;
          }
        }
      },
    );
  }

  // TranslateY
  Widget _buildTranslateYAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      tween: Tween(begin: -1.0, end: 0.0),
      builder: (context, translateY, child) {
        return Opacity(
          opacity: 1.0,
          child: Transform.translate(
            offset: Offset(0.0, translateY * 15),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // TranslateX
  Widget _buildTranslateXAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      tween: Tween(begin: -1.0, end: 0.0),
      builder: (context, translateX, child) {
        return Opacity(
          opacity: 1.0,
          child: Transform.translate(
            offset: Offset(translateX * 15, 0.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // TranslateXReverse
  Widget _buildTranslateXReverseAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: -1.0),
      builder: (context, translateX, child) {
        return Opacity(
          opacity: 1.0,
          child: Transform.translate(
            offset: Offset(translateX * 15, 0.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // FadeIn
  Widget _buildFadeInAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale
  Widget _buildScaleAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  // Rotate
  Widget _buildRotateAnimation() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, rotation, child) {
        return Transform.rotate(
          angle: rotation * 2.0 * 3.1415926535897932,
          child: child,
        );
      },
      child: child,
    );
  }
}
