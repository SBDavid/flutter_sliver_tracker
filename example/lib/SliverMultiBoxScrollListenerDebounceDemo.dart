import 'package:flutter/material.dart';
import 'package:flutter_sliver_tracker/flutter_sliver_tracker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliverMultiBoxScrollListenerDebounceDemo extends StatefulWidget {
  SliverMultiBoxScrollListenerDebounceDemo({Key key,}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SliverMultiBoxScrollListenerDebounceDemo> {
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
                    return SliverMultiBoxScrollListenerDebounce(
                      debounce: 30,
                      maxSpeed: 0.1,
                      notifyOnce: false,
                      onScrollInit: (double percent) {
                        Fluttertoast.showToast(msg: "显示比例：${percent.toStringAsFixed(2)}", fontSize: 16);
                      },
                      onScrollUpdate: (double percent) {
                        // Fluttertoast.showToast(msg: "显示比例：${percent.toStringAsFixed(2)}", fontSize: 16);
                      },
                      onScrollEnd: (double percent) {
                        Fluttertoast.showToast(msg: "显示比例：${percent.toStringAsFixed(2)}", fontSize: 16);
                      },
                      builder: (BuildContext context, double itemLength, double displayedLength) {
                        return Container(
                          height: 400,
                          color: Colors.redAccent,
                          child: Center(
                              child: Text("显示高度：${itemLength == null ? itemLength : itemLength.floor()}, 总高度：${displayedLength == null ? displayedLength : displayedLength.floor()}", style: TextStyle(fontSize: 30, color: Colors.white))
                          ),
                        );
                      },
                    );
                  } else if (index == 2) {
                    return Container(
                        height: 600,
                        color: Colors.amber,
                        child: Center(
                          child: Text("SliverMultiBoxScrollListener 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                        )
                    );
                  } else {
                    return Container(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(height: 100, width: 600, color: Colors.cyan, child: Center(child: Text("333")),)
                        ],
                      ),
                    );
                  }
                },
                childCount: 4
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}