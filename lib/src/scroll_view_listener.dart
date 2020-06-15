import 'package:flutter/material.dart';
import 'dart:async';

class ScrollViewListener extends StatefulWidget {

  final Widget child;

  const ScrollViewListener({Key key, this.child}): super(key: key);

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