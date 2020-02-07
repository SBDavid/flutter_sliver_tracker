import 'package:flutter/material.dart';
import 'package:flutter_sliver_tracker/flutter_sliver_tracker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SliverToBoxAdapterDebounceDemo extends StatefulWidget {
  SliverToBoxAdapterDebounceDemo({Key key,}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SliverToBoxAdapterDebounceDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("SliverToBoxAdapterDebounce Demo"),
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
                  child: Text("SliverToBoxAdapterDebounce 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SliverScrollListenerDebounce(
                maxSpeed: 0.1,
                debounce: 30,
                notifyOnce: true,
                onScrollInit: (double percent) {
                  Fluttertoast.showToast(msg: "显示高度：${percent.toStringAsFixed(2)}");
                },
                onScrollEnd: (double percent) {
                  Fluttertoast.showToast(msg: "显示高度：${percent.toStringAsFixed(2)}");
                },
                onScrollUpdate: (double percent) {
                  Fluttertoast.showToast(msg: "显示高度：${percent.toStringAsFixed(2)}");
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
                height: 1000,
                color: Colors.amber,
                child: Center(
                  child: Text("SliverToBoxAdapterDebounce 没有添加埋点", style: TextStyle(fontSize: 30, color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}