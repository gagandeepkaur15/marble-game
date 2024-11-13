import 'package:flutter/material.dart';
import 'package:four_in_a_row/theme/app_theme.dart';

class GradientElement extends StatelessWidget {
  final Widget child;
  const GradientElement({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            context.theme.primaryColor,
            context.theme.highlightColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
