import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';
import '_debounce.dart';

class SliverMultiBoxScrollUpdateListener extends StatefulWidget {
  final Widget Function(BuildContext context, double displayPercent) builder;
  final Widget child;
  final void Function(double displayPercent) onScrollUpdate;
  final void Function(double displayPercent) onScrollInit;
  final int debounce;
  final double topOverlapCompensation;
  final double bottomOverlapCompensation;

  const SliverMultiBoxScrollUpdateListener({
    Key key,
    this.builder,
    this.child,
    this.onScrollInit,
    this.onScrollUpdate,
    this.debounce = 0,
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

class _State extends State<SliverMultiBoxScrollUpdateListener> with ScrollItemOffsetMixin {

  StreamSubscription sb;
  double displayPercent;
  void Function() _onScrollUpdate;

  @override
  void initState() {
    super.initState();
    displayPercent = 0;

    _onScrollUpdate = debounce(() {
      widget.onScrollUpdate(displayPercent);
    }, widget.debounce);

    Future.microtask(() {
      refreshDisplayPercent();
      widget.onScrollInit(displayPercent);
    });

    sb = ScrollViewListener.of(context).listen((ScrollNotification notification) {

      if (!(notification is ScrollUpdateNotification)) {
        return;
      }

      refreshDisplayPercent();
      _onScrollUpdate();
    });
  }

  void refreshDisplayPercent() {
    double oldDisplayPercent = displayPercent;
    calculateDisplayPercent(context, widget.topOverlapCompensation, widget.bottomOverlapCompensation);

    if (paintExtent == 0) {
      displayPercent = 0;
    } else {
      displayPercent = (itemEndOffsetClamp - itemStartOffsetClamp)/(itemEndOffset - itemStartOffset);
    }

    if (oldDisplayPercent != displayPercent && widget.builder != null) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder != null ? widget.builder(context, displayPercent) : widget.child;
  }

  @override
  void dispose() {
    sb?.cancel();
    super.dispose();
  }
}