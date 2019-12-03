import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'package:flutter/rendering.dart';


/// This Widget will report SliverConstraints and SliverGeometry when ScrollView
/// dispatch EndScroll events through [onScrollEnd] function.
/// When the widget is initiated [onScrollInit] will be called.
class SliverEndScrollListener extends StatefulWidget {
  final Widget child;

  final void Function(
      ScrollEndNotification notification,
      SliverConstraints constraints,
      SliverGeometry geometry) onScrollEnd;

  final void Function(
      SliverConstraints constraints,
      SliverGeometry geometry) onScrollInit;

  const SliverEndScrollListener({Key key, this.child, this.onScrollEnd, this.onScrollInit}): super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverEndScrollListener> {

  // listening ScrollNotification
  StreamSubscription trackSB;

  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed( Duration(milliseconds: 100),() {

      if (widget.onScrollInit != null) {
        RenderSliver renderSliver = context.ancestorRenderObjectOfType(TypeMatcher<RenderSliver>());
        widget.onScrollInit(renderSliver.constraints, renderSliver.geometry);
      }
    });

    trackSB = ScrollViewListener.of(context).listen((ScrollNotification notification) {

      // only take care ScrollEnd
      if (!(notification is ScrollEndNotification)) {
        return;
      }

      if (widget.onScrollEnd != null) {
        RenderSliver renderSliver = context.ancestorRenderObjectOfType(
            TypeMatcher<RenderSliver>());
        widget.onScrollEnd(
            notification, renderSliver.constraints, renderSliver.geometry);
      }
    });
  }

  @override
  void dispose() {
    trackSB?.cancel();
    super.dispose();
  }
}