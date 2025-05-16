
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
        ),
        title: Container(
          height: 16,
          color: Colors.white,
        ),
        subtitle: Container(
          height: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}