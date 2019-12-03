import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';

/// Listening [ScrollEndNotification] from items in Slivers。
/// For example: [SliverList] or [SliverGrid]
/// When the [ScrollEndNotification] is dispatched, each [SliverMultiBoxScrollEndListener]'s
/// [onScrollEnd] will be called。
/// * Scroll items which is not displayed in viewport will not get called.
class SliverMultiBoxScrollEndListener extends StatefulWidget {

  final Widget child;

  // itemLength: the size of box in scroll direction.
  // displayedLength: the size of part be displayed in viewport.
  final void Function(double itemLength, double displayedLength) onScrollEnd;
  final void Function(double itemLength, double displayedLength) onScrollInit;

  const SliverMultiBoxScrollEndListener({Key key, this.child, this.onScrollEnd, this.onScrollInit}): super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverMultiBoxScrollEndListener> with ScrollItemOffsetMixin {

  StreamSubscription trackSB;

  @override
  void initState() {
    super.initState();

    Future.delayed( Duration(milliseconds: 100),() {

      if (widget.onScrollInit != null) {
        calculateDisplayPercent(context);
        if (paintExtent > 0) {
          widget.onScrollInit(itemEndOffset - itemStartOffset,
              itemEndOffsetClamp - itemStartOffsetClamp);
        }
      }
    });

    trackSB = ScrollViewListener.of(context).listen((ScrollNotification notification) {
      if (!(notification is ScrollEndNotification)) {
        return;
      }

      if (widget.onScrollEnd != null) {
        calculateDisplayPercent(context);
        if (paintExtent > 0) {
          widget.onScrollInit(itemEndOffset - itemStartOffset,
              itemEndOffsetClamp - itemStartOffsetClamp);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    trackSB?.cancel();
    super.dispose();
  }
}