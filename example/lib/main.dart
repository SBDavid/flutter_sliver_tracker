import 'package:flutter/material.dart';
import 'package:xm_sliver_listener/xm_sliver_listener.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SliverListenerDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SliverListenerDemo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: ScrollViewListener(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              title: Text("Listen Scroll End in SliverToBoxAdapter"),
              pinned: true,
            ),

            SliverToBoxAdapter(
              child: SliverEndScrollListener(
                onScrollInit: (SliverConstraints constraints, SliverGeometry geometry) {
                  //Fluttertoast.showToast(msg: "显示高度：${geometry.paintExtent}");
                },
                onScrollEnd: (ScrollEndNotification notification,
                    SliverConstraints constraints,
                    SliverGeometry geometry) {
                  // Fluttertoast.showToast(msg: "显示高度：${geometry.paintExtent}");
                },
                child: Container(
                  height: 300,
                  color: Colors.amber,
                  child: Center(
                    child: Text("Pull to show paintExtent", style: TextStyle(fontSize: 30, color: Colors.white),),
                  ),
                ),
              ),
            ),

            SliverAppBar(
              title: Text("Listen Scroll End in SliverList"),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SliverMultiBoxScrollEndListener(
                    child: Container(
                      height: 300,
                      color: Colors.redAccent,
                      child: Center(
                        child: Text("SliverList Item", style: TextStyle(fontSize: 30, color: Colors.white))
                      ),
                    ),
                    onScrollInit: (double itemLength, double displayedLength) {
                      // Fluttertoast.showToast(msg: "显示高度：${displayedLength}");
                    },
                    onScrollEnd: (double itemLength, double displayedLength) {
                      // Fluttertoast.showToast(msg: "显示高度：${displayedLength}");
                    },
                  );
                },
                childCount: 1
              ),
            ),
            SliverAppBar(
              title: Text("Listen Scroll End in SliverGrid"),
              pinned: true,
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return SliverMultiBoxScrollEndListener(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.teal[100 * (index % 9)],
                      child: Text('Grid Item $index'),
                    ),
                    onScrollInit: (double itemLength, double displayedLength) {
                      Fluttertoast.showToast(msg: "显示高度：$displayedLength");
                    },
                    onScrollEnd: (double itemLength, double displayedLength) {
                      Fluttertoast.showToast(msg: "显示高度：$displayedLength");
                    },
                  );
                },
                childCount: 2,
              ),
            ),
            SliverAppBar(
              title: Text("Listen Scroll Update in SliverList"),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return SliverMultiBoxScrollUpdateListener(
                      builder: (BuildContext context, double percent) {
                        return Container(
                          height: 200,
                          color: Colors.amber.withAlpha((percent * 255).toInt()),
                          child: Center(
                              child: Text("SliverList Item Percent ${percent.toStringAsFixed(2)}", style: TextStyle(fontSize: 30, color: Colors.white))
                          ),
                        );
                      },
                    );
                  },
                  childCount: 3
              ),
            ),
            SliverAppBar(
              title: Text("End"),
              pinned: true,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
