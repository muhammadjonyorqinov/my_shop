import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: null,
        baseColor: Colors.grey[360],
        highlightColor: Colors.white);
  }
}
