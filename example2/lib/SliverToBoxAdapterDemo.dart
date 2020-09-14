import 'package:flutter/material.dart';
import 'package:flutter_sliver_tracker/flutter_sliver_tracker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliverToBoxAdapterDemo extends StatefulWidget {
  SliverToBoxAdapterDemo({Key key,}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SliverToBoxAdapterDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("SliverToBoxAdapter Demo"),
      ),
      body: ScrollViewListener(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 600,
                color: Colors.amber,
                child: Center(
                  child: Text("SliverToBoxAdapter 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SliverScrollListener(
                onScrollInit: (SliverConstraints constraints, SliverGeometry geometry) {
                  Fluttertoast.showToast(msg: "显示高度：${geometry.paintExtent.floor()}, 总高度：${geometry.scrollExtent}");
                },
                onScrollEnd: (ScrollEndNotification notification,
                    SliverConstraints constraints,
                    SliverGeometry geometry) {
                  Fluttertoast.showToast(msg: "显示高度：${geometry.paintExtent.floor()}, 总高度：${geometry.scrollExtent}");
                },
                onScrollUpdate: (ScrollUpdateNotification notification,
                    SliverConstraints constraints,
                    SliverGeometry geometry) {
                  Fluttertoast.showToast(msg: "显示高度：${geometry.paintExtent.floor()}, 总高度：${geometry.scrollExtent}");
                },
                child: Container(
                  height: 400,
                  color: Colors.deepPurple,
                  child: Center(
                    child: Text("SliverToBoxAdapter 添加了埋点，你可以通过滑动来查看效果", style: TextStyle(fontSize: 30, color: Colors.white),),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 600,
                color: Colors.amber,
                child: Center(
                  child: Text("SliverToBoxAdapter 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}