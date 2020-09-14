import 'package:flutter/material.dart';
import '_debounce.dart';

import 'sliver_multi_box_scroll_lintener.dart';
import 'scroll_speed_mixin.dart';

class SliverMultiBoxScrollListenerDebounce extends StatefulWidget {

  final Widget Function(BuildContext context, double itemLength, double displayedLength, double parentDisplayRate) builder;
  final Widget child;
  final void Function(double percent) onScrollInit;
  final void Function(double percent) onScrollUpdate;
  final void Function(double percent) onScrollEnd;
  final double topOverlapCompensation;
  final double bottomOverlapCompensation;

  final int debounce;
  // 触发滑动埋点事件的最小露出比例
  final double minPaintPercent;
  // 最小触发速度
  final double maxSpeed;
  // 是否只触发一次
  final bool notifyOnce;

  const SliverMultiBoxScrollListenerDebounce({
    Key key,
    this.builder,
    this.child,
    this.onScrollInit,
    this.onScrollUpdate,
    this.onScrollEnd,
    this.topOverlapCompensation = 0,
    this.bottomOverlapCompensation = 0,
    this.debounce = 0,
    this.minPaintPercent = 0.5,
    this.maxSpeed = 100,
    this.notifyOnce = false,
  }): assert(debounce >= 0),
      assert(maxSpeed >= 0),
      super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverMultiBoxScrollListenerDebounce> with ScrollSpeedMixin {

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
    return SliverMultiBoxScrollListener(
      builder: widget.builder,
      child: widget.child,
      topOverlapCompensation: widget.topOverlapCompensation,
      bottomOverlapCompensation: widget.bottomOverlapCompensation,
      onScrollInit: _onScrollInit,
      onScrollUpdate: _onScrollUpdate,
      onScrollEnd: _onScrollEnd,
    );
  }

  void _onScrollInit(double itemLength, double displayedLength) {
    // 更新展示比例
    currentPaintPercent = displayedLength / itemLength;
    if (currentPaintPercent >= widget.minPaintPercent
        && widget.onScrollInit != null) {
      widget.onScrollInit(currentPaintPercent);
      if (widget.notifyOnce)
        hasNotified = true;
    }
  }

  void _onScrollUpdate(ScrollUpdateNotification notification ,double itemLength, double displayedLength) {

    // 更新速度
    scrollSpeedEndUpdate(notification);
    // 更新展示比例
    currentPaintPercent = displayedLength / itemLength;

    if (hasNotified == false) {
      // 满足曝光条件
      if (currentPaintPercent >= widget.minPaintPercent
          && velocity.abs() <= widget.maxSpeed
          && widget.onScrollUpdate != null) {
        _onScrollUpdateDebounce();
      }
    } else {
      if (displayedLength == 0) {
        hasNotified = false;
      }
    }
  }

  void _onScrollEnd(ScrollEndNotification notification, double itemLength, double displayedLength) {

    // 更新展示比例
    currentPaintPercent = displayedLength / itemLength;

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