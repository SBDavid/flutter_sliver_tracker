import 'package:flutter/material.dart';
import 'dart:async';

// 包裹在ScrollView外侧，用户监听滚动事件
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
  // 目标ScrollableState
  ScrollableState _scrollableState;
  @override
  void initState() {
    super.initState();
    controller = StreamController<ScrollNotification>();
    broadCaseStream = controller.stream.asBroadcastStream();

    // 确定当前ScrollableState
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Element childEle = context;
      while(childEle != null) {
        if (childEle.widget is Scrollable) {
          _scrollableState = (childEle as StatefulElement).state;
          break;
        } else {
          childEle.visitChildElements((Element element) {
            childEle = element;
          });
        }
      }
    });
  }

  bool _isCurrentScrollNotification(ScrollNotification notification) {
    return Scrollable.of(notification.context) == _scrollableState;
  }
  
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {

          if (_isCurrentScrollNotification(notification)) {
            controller.sink.add(notification);

            if (notification is ScrollEndNotification && widget.onScrollEnd != null) {
              this.widget.onScrollEnd(notification);
            }
            if (notification is ScrollUpdateNotification && widget.onScrollEnd != null) {
              this.widget.onScrollUpdate(notification);
            }
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