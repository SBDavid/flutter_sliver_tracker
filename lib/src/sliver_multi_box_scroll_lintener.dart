import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';

class SliverMultiBoxScrollListener extends StatefulWidget {
  final Widget Function(BuildContext context, double itemLength, double displayedLength, double parentDisplayRate) builder;
  final Widget child;
  final void Function(double itemLength, double displayedLength) onScrollInit;
  final void Function(ScrollUpdateNotification notification, double itemLength, double displayedLength) onScrollUpdate;
  final void Function(ScrollEndNotification notification, double itemLength, double displayedLength) onScrollEnd;
  final double topOverlapCompensation;
  final double bottomOverlapCompensation;

  const SliverMultiBoxScrollListener({
    Key key,
    this.builder,
    this.child,
    this.onScrollInit,
    this.onScrollUpdate,
    this.onScrollEnd,
    this.topOverlapCompensation = 0,
    this.bottomOverlapCompensation = 0,
  }):
      assert(child == null || builder == null, "不可以同时使用builder和child"),
      super(key: key);

  @override
  _State createState() {
    return _State();
  }

  // 用于查询父级的曝光情况，用于嵌套
  static double of(BuildContext context) {
    _State state = (context.ancestorStateOfType(TypeMatcher<_State>()) as _State);
    if (state == null) {
      // 没有检测到嵌套
      return 1.0;
    } else {
      return state.displayedLength / state.itemLength;
    }
  }
}

class _State extends State<SliverMultiBoxScrollListener> with ScrollItemOffsetMixin {

  StreamSubscription sb;
  double itemLength;
  double displayedLength;
  double parentDisplayRate;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshDisplayPercent();
      if (widget.onScrollInit != null) {
        widget.onScrollInit(itemLength, displayedLength*SliverMultiBoxScrollListener.of(context));
      }
    });

    sb = ScrollViewListener.of(context).listen((ScrollNotification notification) {
      refreshDisplayPercent();
      parentDisplayRate = SliverMultiBoxScrollListener.of(context);
      if (notification is ScrollUpdateNotification && widget.onScrollUpdate != null) {
        widget.onScrollUpdate(notification, itemLength, displayedLength * parentDisplayRate);
      }

      if (notification is ScrollEndNotification && widget.onScrollEnd != null) {
        widget.onScrollEnd(
            notification, itemLength, displayedLength * parentDisplayRate);
      }
    });
  }

  void refreshDisplayPercent() {
    double oldDisplayedLength = displayedLength;
    calculateDisplayPercent(context, widget.topOverlapCompensation, widget.bottomOverlapCompensation);

    if (paintExtent == 0) {
      displayedLength = null;
    } else {
      displayedLength = itemEndOffsetClamp - itemStartOffsetClamp;
      itemLength = itemEndOffset - itemStartOffset;
    }

    // 有可能降低性能
    /*if (oldDisplayedLength != displayedLength && widget.builder != null) {
      setState(() {

      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder != null ? widget.builder(context, itemLength, displayedLength, parentDisplayRate) : widget.child;
  }

  @override
  void dispose() {

    try {
      sb?.cancel();
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }
}