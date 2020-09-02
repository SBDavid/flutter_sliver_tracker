import 'package:flutter/material.dart';
import 'dart:async';

class ScrollViewListener extends StatefulWidget {

  final Widget child;
  final void Function(ScrollEndNotification) onScrollEnd;
  final void Function(ScrollUpdateNotification) onScrollUpdate;

  const ScrollViewListener({Key key, this.child, this.onScrollEnd, this.onScrollUpdate}): super(key: key);

  @override
  ScrollViewListenerState createState() {
    return ScrollViewListenerState();
  }

  static Stream<ScrollNotification> of(BuildContext context) {
    return (context.ancestorStateOfType(TypeMatcher<ScrollViewListenerState>()) as ScrollViewListenerState).broadCaseStream;
  }
}

class ScrollViewListenerState extends State<ScrollViewListener> {

  StreamController<ScrollNotification> controller;
  Stream<ScrollNotification> broadCaseStream;

  @override
  void initState() {
    super.initState();
    controller = StreamController<ScrollNotification>();
    broadCaseStream = controller.stream.asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          controller.sink.add(notification);

          if (notification is ScrollEndNotification && widget.onScrollEnd != null) {
            this.widget.onScrollEnd(notification);
          }
          if (notification is ScrollUpdateNotification && widget.onScrollEnd != null) {
            this.widget.onScrollUpdate(notification);
          }

          return false;
        },
        child: widget.child
    );
  }

  @override
  void dispose() {
    try {
      controller?.close();
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }
}