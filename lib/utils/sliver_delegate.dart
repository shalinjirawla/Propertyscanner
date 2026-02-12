import 'package:flutter/material.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(
    this._tabBar,
    this.minHeight,
    this.maxHeight,
  );

  final double minHeight;
  final double maxHeight;

  final Widget _tabBar;

  @override
  double get minExtent => minHeight; //55;

  @override
  double get maxExtent => maxHeight; //55;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
