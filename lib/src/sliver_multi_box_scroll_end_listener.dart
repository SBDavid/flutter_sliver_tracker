import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'scroll_item_offset_mixin.dart';
import '_debounce.dart';

/// Listening [ScrollEndNotification] from items in Slivers。
/// For example: [SliverList] or [SliverGrid]
/// When the [ScrollEndNotification] is dispatched, each [SliverMultiBoxScrollEndListener]'s
/// [onScrollEnd] will be called。
/// * Scroll items which is not displayed in viewport will not get called.
class SliverMultiBoxScrollEndListener extends StatefulWidget {

  final Widget child;
  final int debounce;

  // itemLength: the size of box in scroll direction.
  // displayedLength: the size of part be displayed in viewport.
  final void Function(double itemLength, double displayedLength) onScrollEnd;
  final void Function(double itemLength, double displayedLength) onScrollInit;
  final double topOverlapCompensation;
  final double bottomOverlapCompensation;

  const SliverMultiBoxScrollEndListener({
    Key key,
    this.child,
    this.onScrollEnd,
    this.onScrollInit,
    this.debounce = 0,
    this.topOverlapCompensation = 0,
    this.bottomOverlapCompensation = 0,
  }): super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverMultiBoxScrollEndListener> with ScrollItemOffsetMixin {

  StreamSubscription trackSB;

  void Function() _onScrollEnd;

  @override
  void initState() {
    super.initState();

    _onScrollEnd = debounce(() {
      widget.onScrollEnd(itemEndOffset - itemStartOffset,
          itemEndOffsetClamp - itemStartOffsetClamp);
    }, widget.debounce);

    Future.delayed( Duration(milliseconds: 100),() {

      if (widget.onScrollInit != null) {
        calculateDisplayPercent(context, widget.topOverlapCompensation, widget.bottomOverlapCompensation);
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
        calculateDisplayPercent(context, widget.topOverlapCompensation, widget.bottomOverlapCompensation);
        if (paintExtent > 0) {
          _onScrollEnd();
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