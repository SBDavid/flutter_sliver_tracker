import 'package:flutter/material.dart';
import 'dart:async';
import 'scroll_view_listener.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';


/// This Widget will report SliverConstraints and SliverGeometry when ScrollView
/// dispatch EndScroll events through [onScrollEnd] function.
/// When the widget is initiated [onScrollInit] will be called.
class SliverScrollListener extends StatefulWidget {
  final Widget child;

  final void Function(
      ScrollEndNotification notification,
      SliverConstraints constraints,
      SliverGeometry geometry) onScrollEnd;

  final void Function(
      ScrollUpdateNotification notification,
      SliverConstraints constraints,
      SliverGeometry geometry) onScrollUpdate;

  final void Function(
      SliverConstraints constraints,
      SliverGeometry geometry) onScrollInit;

  const SliverScrollListener({
    Key key,
    this.child,
    this.onScrollEnd,
    this.onScrollUpdate,
    this.onScrollInit,
  }): super(key: key);

  @override
  _State createState() {
    return _State();
  }
}

class _State extends State<SliverScrollListener> {

  void Function(ScrollUpdateNotification notification) _onScrollUpdate;

  // listening ScrollNotification
  StreamSubscription trackSB;

  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      try {
        if (widget.onScrollInit != null) {
          RenderSliver renderSliver = context.findAncestorRenderObjectOfType();
          widget.onScrollInit(renderSliver.constraints, renderSliver.geometry);
        }
      } catch (err) {

      }
    });

    trackSB = ScrollViewListener.of(context).listen((ScrollNotification notification) {

      // ScrollEnd
      if (notification is ScrollEndNotification) {
        if (widget.onScrollEnd != null) {
          RenderSliver renderSliver = context.findAncestorRenderObjectOfType();
          widget.onScrollEnd(
              notification, renderSliver.constraints, renderSliver.geometry);
        }
      }

      // ScrollUpdate
      if (notification is ScrollUpdateNotification) {
        if (widget.onScrollUpdate != null) {
          RenderSliver renderSliver = context.findAncestorRenderObjectOfType();
          widget.onScrollUpdate(
              notification, renderSliver.constraints, renderSliver.geometry);
        }
      }
    });
  }

  @override
  void dispose() {
    try {
      trackSB?.cancel();
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }
}