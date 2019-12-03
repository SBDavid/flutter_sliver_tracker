import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';

class SliverMultiBoxScrollUpdateListener extends StatefulWidget {
  final Widget Function(BuildContext context, double displayPercent) builder;

  const SliverMultiBoxScrollUpdateListener({Key key, this.builder,}): super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverMultiBoxScrollUpdateListener> with ScrollItemOffsetMixin {

  StreamSubscription sb;
  double displayPercent;

  @override
  void initState() {
    super.initState();
    displayPercent = 0;

    Future.microtask(() {
      refreshDisplayPercent();
    });

    sb = ScrollViewListener.of(context).listen((ScrollNotification notification) {

      if (!(notification is ScrollUpdateNotification)) {
        return;
      }

      refreshDisplayPercent();
    });
  }

  void refreshDisplayPercent() {
    double oldDisplayPercent = displayPercent;
    calculateDisplayPercent(context);

    if (paintExtent == 0) {
      displayPercent = 0;
    } else {
      displayPercent = (itemEndOffsetClamp - itemStartOffsetClamp)/(itemEndOffset - itemStartOffset);
    }

    if (oldDisplayPercent != displayPercent) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, displayPercent);
  }

  @override
  void dispose() {
    sb?.cancel();
    super.dispose();
  }
}