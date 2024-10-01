import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!widget.isLoading) {
      return widget.child;
    }

    return Shimmer.fromColors(
        baseColor: !isDark ? const Color(0xFFDADADA) : const Color(0xFF333333),
        highlightColor:
            !isDark ? const Color(0xFFF4F4F4) : const Color(0xFF555555),
        child: widget.child);
  }
}
