import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'package:flutter/rendering.dart';
import '_debounce.dart';

import 'sliver_scroll_listener.dart';
import 'scroll_speed_mixin.dart';

// 在SliverToBoxAdapter上使用，可以配置Debounce，以及是否只触发一次
class SliverScrollListenerDebounce extends StatefulWidget {

  final Widget child;
  final int debounce;
  // 触发滑动埋点事件的最小露出比例
  final double minPaintPercent;
  // 最小触发速度
  final double maxSpeed;
  // 是否只触发一次
  final bool notifyOnce;

  final void Function(double percent) onScrollEnd;

  final void Function(double percent) onScrollUpdate;

  final void Function(double percent) onScrollInit;

  const SliverScrollListenerDebounce({
    Key key,
    this.child,
    this.debounce = 0,
    this.minPaintPercent = 0.5,
    this.maxSpeed = 100,
    this.notifyOnce = false,
    this.onScrollEnd,
    this.onScrollUpdate,
    this.onScrollInit,
  }): assert(debounce >= 0),
      assert(maxSpeed >= 0),
      super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SliverScrollListenerDebounce> with ScrollSpeedMixin {

  // 是否已被触发，当组件离开ViewPort时这个状态将重置
  bool hasNotified = false;
  // 当前显示比例
  double currentPaintPercent = 0;

  Function _onScrollUpdateDebounce;

  @override
  void initState() {
    super.initState();

    _onScrollUpdateDebounce = debounce(() {
      widget.onScrollUpdate(currentPaintPercent);
      if (widget.notifyOnce)
        hasNotified = true;
    }, widget.debounce);
  }

  @override
  Widget build(BuildContext context) {
    return SliverScrollListener(
      child: widget.child,
      onScrollInit: _onScrollInit,
      onScrollUpdate: _onScrollUpdate,
      onScrollEnd: _onScrollEnd,
    );
  }

  void _onScrollInit(SliverConstraints constraints, SliverGeometry geometry) {
    // 更新展示比例
    currentPaintPercent = geometry.paintExtent / geometry.scrollExtent;
    if (currentPaintPercent >= widget.minPaintPercent
        && widget.onScrollInit != null) {
      widget.onScrollInit(currentPaintPercent);
      if (widget.notifyOnce)
        hasNotified = true;
    }
  }

  void _onScrollUpdate(ScrollUpdateNotification notification,
      SliverConstraints constraints, SliverGeometry geometry) {

    // 更新速度
    scrollSpeedEndUpdate(notification);
    // 更新展示比例
    currentPaintPercent = geometry.paintExtent / geometry.scrollExtent;

    if (hasNotified == false) {
      // 满足曝光条件
      if (currentPaintPercent >= widget.minPaintPercent
          && velocity.abs() <= widget.maxSpeed
          && widget.onScrollUpdate != null) {
        _onScrollUpdateDebounce();
      }
    } else {
      if (geometry.paintExtent == 0) {
        hasNotified = false;
      }
    }
  }

  void _onScrollEnd(ScrollEndNotification notification,
    SliverConstraints constraints,
    SliverGeometry geometry) {

    // 更新展示比例
    currentPaintPercent = geometry.paintExtent / geometry.scrollExtent;

    if (currentPaintPercent >= widget.minPaintPercent
        && widget.onScrollEnd != null) {
      if (hasNotified == false) {
        widget.onScrollEnd(currentPaintPercent);
        if (widget.notifyOnce)
          hasNotified = true;
      }
    }
  }
}