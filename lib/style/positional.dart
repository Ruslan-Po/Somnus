import 'package:flutter/material.dart';

class ListFadeOverlay extends StatelessWidget {
  final Color fadeColor;
  final double height;

  const ListFadeOverlay({
    super.key,
    this.fadeColor = Colors.white,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: [
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  fadeColor,
                  fadeColor.withValues(
                    alpha: 0,
                  )
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  fadeColor,
                  fadeColor.withValues(
                    alpha: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
