import 'package:flutter/material.dart';

class SpeakingIndicator extends StatefulWidget {
  final bool isSpeaking;

  const SpeakingIndicator({Key? key, required this.isSpeaking})
      : super(key: key);

  @override
  _SpeakingIndicatorState createState() => _SpeakingIndicatorState();
}

class _SpeakingIndicatorState extends State<SpeakingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_animationController);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.3).animate(_animationController);
    if (widget.isSpeaking) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SpeakingIndicator oldWidget) {
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.volume_up,
              size: 24,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
