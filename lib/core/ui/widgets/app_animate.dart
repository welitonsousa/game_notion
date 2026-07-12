import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// use this enum to define animation type
enum AppAnimateType {
  none,
  fadeIn,
  fadeInDown,
  fadeInDownBig,
  fadeInUp,
  fadeInUpBig,
  fadeInLeft,
  fadeInLeftBig,
  fadeInRight,
  fadeInRightBig,

  fadeOut,
  fadeOutDown,
  fadeOutDownBig,
  fadeOutUp,
  fadeOutUpBig,
  fadeOutLeft,
  fadeOutLeftBig,
  fadeOutRight,
  fadeOutRightBig,

  bounceInDown,
  bounceInUp,
  bounceInLeft,
  bounceInRight,

  elasticIn,
  elasticInDown,
  elasticInUp,
  elasticInLeft,
  elasticInRight,

  slideInDown,
  slideInUp,
  slideInLeft,
  slideInRight,

  flipInX,
  flipInY,

  zoomIn,
  zoomOut,

  jelloIn,
  bounce,
  flash,
  pulse,
  swing,
  spin,
  spinPerfect,
  dance,
  roulette,
}

/// use this widget to animate your widgets
///
/// example:
///
/// ```dart
/// AppAnimate(
///   type: AppAnimateType.fadeInDownBig,
///   duration: const Duration(seconds: 1),
///   child: Text('Text H1', style: context.H1),
/// ),
class AppAnimate extends StatelessWidget {
  final AppAnimateType type;
  final Duration delay;
  final Duration duration;
  final Widget child;

  /// use this widget to animate your widgets
  ///
  /// example:
  ///
  /// ```dart
  /// AppAnimate(
  ///   type: AppAnimateType.fadeInDownBig,
  ///   duration: const Duration(seconds: 1),
  ///   child: Text('Text H1', style: context.H1),
  /// ),
  /// ```
  const AppAnimate({
    super.key,
    required this.type,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    if (type == AppAnimateType.fadeIn) {
      return FadeIn(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInDown) {
      return FadeInDown(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInDownBig) {
      return FadeInDownBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInUp) {
      return FadeInUp(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInUpBig) {
      return FadeInUpBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInLeft) {
      return FadeInLeft(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInLeftBig) {
      return FadeInLeftBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInRight) {
      return FadeInRight(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeInRightBig) {
      return FadeInRightBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.fadeOut) {
      return FadeOut(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutDown) {
      return FadeOutDown(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutDownBig) {
      return FadeOutDownBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutUp) {
      return FadeOutUp(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutUpBig) {
      return FadeOutUpBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutLeft) {
      return FadeOutLeft(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutLeftBig) {
      return FadeOutLeftBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutRight) {
      return FadeOutRight(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.fadeOutRightBig) {
      return FadeOutRightBig(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.bounceInDown) {
      return BounceInDown(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.bounceInUp) {
      return BounceInUp(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.bounceInLeft) {
      return BounceInLeft(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.bounceInRight) {
      return BounceInRight(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.elasticIn) {
      return ElasticIn(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.elasticInDown) {
      return ElasticInDown(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.elasticInUp) {
      return ElasticInUp(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.elasticInLeft) {
      return ElasticInLeft(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.elasticInRight) {
      return ElasticInRight(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.slideInDown) {
      return SlideInDown(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.slideInUp) {
      return SlideInUp(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.slideInLeft) {
      return SlideInLeft(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.slideInRight) {
      return SlideInRight(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.flipInX) {
      return FlipInX(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.flipInY) {
      return FlipInY(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.zoomIn) {
      return ZoomIn(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.zoomOut) {
      return ZoomOut(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.jelloIn) {
      return JelloIn(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    if (type == AppAnimateType.bounce) {
      return Bounce(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.flash) {
      return Flash(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.pulse) {
      return Pulse(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.swing) {
      return Swing(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.spin) {
      return Spin(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.spinPerfect) {
      return SpinPerfect(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.dance) {
      return Dance(
        delay: delay,
        duration: duration,
        child: child,
      );
    }
    if (type == AppAnimateType.roulette) {
      return Roulette(
        delay: delay,
        duration: duration,
        child: child,
      );
    }

    return child;
  }
}
