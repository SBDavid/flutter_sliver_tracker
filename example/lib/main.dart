import 'package:flutter/material.dart';
import 'package:flutter_sliver_tracker/flutter_sliver_tracker.dart';
import 'dart:math';

import 'SliverToBoxAdapterDemo.dart';
import 'SliverToBoxAdapterDebounceDemo.dart';
import 'SliverMultiBoxScrollListenerDemo.dart';
import 'SliverMultiBoxScrollListenerDebounceDemo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SliverListenerDemo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            button: TextStyle(fontSize: 30),
            display1: TextStyle(fontSize: 40),
            display2: TextStyle(fontSize: 40),
            display3: TextStyle(fontSize: 40),
            display4: TextStyle(fontSize: 40),
            headline: TextStyle(fontSize: 40),
            title: TextStyle(fontSize: 40),
            subhead: TextStyle(fontSize: 40),
            body1: TextStyle(fontSize: 20, color: Colors.white),
          )
      ),
      home: MyHomePage(title: 'flutter_sliver_tracker demo'),
      routes: {
        "SliverToBoxAdapterDemo": (_) => SliverToBoxAdapterDemo(),
        "SliverToBoxAdapterDebounceDemo": (_) => SliverToBoxAdapterDebounceDemo(),
        "SliverMultiBoxScrollListenerDemo": (_) => SliverMultiBoxScrollListenerDemo(),
        "SliverMultiBoxScrollListenerDebounceDemo": (_) => SliverMultiBoxScrollListenerDebounceDemo(),
      },
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

  Widget _button(String text, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.amber[500 + 100 * Random().nextInt(4)],
          height: 50,
          child: Center(
            child: Text(text),
          ),
        )
    );
  }

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
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("滑动曝光埋点用于滑动列表组件中的模块曝光，例如 Flutter 中的 SliverList、SliverGrid。"
                    "当 SliverList 中的某一个行（或列）移动到 ViewPort 中，并且显示比例超过一定阈值时，"
                        "我们把这个事件记为一次滑动曝光事件。"),
                    Container(height: 50,),
                    Text("目前 flutter_sliver_tracker 支持 SliverList 以及 SliverGrid。"),
                    Container(height: 15,),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _button(
                      'SliverToBoxAdapter Demo',
                          () {
                        Navigator.of(context).pushNamed("SliverToBoxAdapterDemo");
                      }
                  ),
                  _button(
                      'SliverToBoxAdapterDebounce Demo',
                          () {
                        Navigator.of(context).pushNamed("SliverToBoxAdapterDebounceDemo");
                      }
                  ),
                  _button(
                      'SliverMultiBoxScrollListener Demo',
                          () {
                        Navigator.of(context).pushNamed("SliverMultiBoxScrollListenerDemo");
                      }
                  ),
                  _button(
                      'SliverMultiBoxScrollListenerDebounce Demo',
                          () {
                        Navigator.of(context).pushNamed("SliverMultiBoxScrollListenerDebounceDemo");
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
