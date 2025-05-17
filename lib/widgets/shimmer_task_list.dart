import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class ShimmerTaskList extends StatelessWidget {
  final int itemCount;
  const ShimmerTaskList({this.itemCount = 5, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.defaultPadding,
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
} 