import 'package:flutter/material.dart';
import 'package:flutter_sliver_tracker/flutter_sliver_tracker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliverMultiBoxScrollListenerDemo extends StatefulWidget {
  SliverMultiBoxScrollListenerDemo({Key key,}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SliverMultiBoxScrollListenerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("SliverMultiBoxScrollListener Demo"),
      ),
      body: ScrollViewListener(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                        height: 600,
                        color: Colors.amber,
                        child: Center(
                        child: Text("SliverMultiBoxScrollListener 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                      )
                    );
                  } else if (index == 1) {
                    return SliverMultiBoxScrollListener(
                      onScrollInit: (double itemLength, double displayedLength) {
                        Fluttertoast.showToast(msg: "显示高度：${itemLength == null ? itemLength : itemLength.floor()}, 总高度：${displayedLength == null ? displayedLength : displayedLength.floor()}");
                      },
                      onScrollUpdate: (_, double itemLength, double displayedLength) {
                        Fluttertoast.showToast(msg: "显示高度：${itemLength == null ? itemLength : itemLength.floor()}, 总高度：${displayedLength == null ? displayedLength : displayedLength.floor()}");
                      },
                      onScrollEnd: (_, double itemLength, double displayedLength) {
                        Fluttertoast.showToast(msg: "显示高度：${itemLength == null ? itemLength : itemLength.floor()}, 总高度：${displayedLength == null ? displayedLength : displayedLength.floor()}");
                      },
                      builder: (BuildContext context, double itemLength, double displayedLength, double parentDisplayRate) {
                        return Container(
                          height: 300,
                          color: Colors.redAccent,
                          child: Center(
                              child: Text("显示高度：${itemLength == null ? itemLength : itemLength.floor()}, 总高度：${displayedLength == null ? displayedLength : displayedLength.floor()}", style: TextStyle(fontSize: 30, color: Colors.white))
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                        height: 1000,
                        color: Colors.amber,
                        child: Center(
                          child: Text("SliverMultiBoxScrollListener 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                        )
                    );
                  }
                },
                childCount: 3
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}