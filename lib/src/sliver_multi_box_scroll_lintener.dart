import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';

class SliverMultiBoxScrollListener extends StatefulWidget {
  final Widget Function(BuildContext context, double itemLength, double displayedLength) builder;
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
}

class _State extends State<SliverMultiBoxScrollListener> with ScrollItemOffsetMixin {

  StreamSubscription sb;
  double itemLength;
  double displayedLength;


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      refreshDisplayPercent();
      if (widget.onScrollInit != null) {
        widget.onScrollInit(displayedLength, itemLength);
      }
    });

    sb = ScrollViewListener.of(context).listen((ScrollNotification notification) {
      refreshDisplayPercent();
      if (notification is ScrollUpdateNotification && widget.onScrollUpdate != null)
        widget.onScrollUpdate(notification, displayedLength, itemLength);

      if (notification is ScrollEndNotification && widget.onScrollEnd != null)
        widget.onScrollEnd(notification, displayedLength, itemLength);
    });
  }

  void refreshDisplayPercent() {
    double oldDisplayedLength = displayedLength;
    calculateDisplayPercent(context, widget.topOverlapCompensation, widget.bottomOverlapCompensation);

    if (paintExtent == 0) {
      displayedLength = null;
    } else {
      itemLength = itemEndOffsetClamp - itemStartOffsetClamp;
      displayedLength = itemEndOffset - itemStartOffset;
    }

    if (oldDisplayedLength != displayedLength && widget.builder != null) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder != null ? widget.builder(context, itemLength, displayedLength) : widget.child;
  }

  @override
  void dispose() {

    try {
      sb?.cancel();
    } catch (err) {}

    super.dispose();
  }
}