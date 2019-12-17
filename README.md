# flutter_sliver_tracker

滑动曝光埋点框架，支持SliverList、SliverGrid

![demo](./demo.gif 960*540)

## 1. 安装

```yaml
dependencies:
  flutter_sliver_tracker: ^1.0.0
```

## 2. 引用
```dart
import 'package:xm_sliver_listener/flutter_sliver_tracker.dart';
```

## 3. 发送滑动埋点事件

### 3.1 通过`ScrollViewListener`捕获滚动事件，`ScrollViewListener`必须包裹在`CustomScrollView`之上。

```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 通过ScrollViewListener捕获滚动事件
      body: ScrollViewListener(
        child: CustomScrollView(
          slivers: <Widget>[
          ],
        ),
      ),
    );
  }
}
```

### 3.2 在`SliverToBoxAdapter`中监听滚动停止事件，并计算显示比例
```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 通过ScrollViewListener捕获滚动事件
      body: ScrollViewListener(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              // 监听停止事件，如果在页面上展示比例，可以自行setState
              child: SliverEndScrollListener(
                onScrollInit: (SliverConstraints constraints, SliverGeometry geometry) {
                  // 显示高度 / sliver高度
                  Fluttertoast.showToast(msg: "展示比例：${geometry.paintExtent / geometry.scrollExtent}");
                },
                onScrollEnd: (ScrollEndNotification notification,
                    SliverConstraints constraints,
                    SliverGeometry geometry) {
                  Fluttertoast.showToast(msg: "展示比例：${geometry.paintExtent / geometry.scrollExtent}");
                },
                child: Container(
                  height: 300,
                  color: Colors.amber,
                 
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3.3 在`SliverList`和`SliverGrid`中监听滚动停止事件，并计算显示比例

- itemLength：列表项布局高度
- displayedLength：列表项展示高度
- 如果需要在widget中显示高度，可以自行setState

```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 通过ScrollViewListener捕获滚动事件
      body: ScrollViewListener(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // 监听滚动停止
                  return SliverMultiBoxScrollEndListener(
                    debounce: 1000,
                    child: Container(
                      height: 300,
                      color: Colors.redAccent,
                      child: Center(
                        child: Text("SliverList Item", style: TextStyle(fontSize: 30, color: Colors.white))
                      ),
                    ),
                    onScrollInit: (double itemLength, double displayedLength) {
                      Fluttertoast.showToast(msg: "显示高度：${displayedLength}");
                    },
                    onScrollEnd: (double itemLength, double displayedLength) {
                      Fluttertoast.showToast(msg: "显示高度：${displayedLength}");
                    },
                  );
                },
                childCount: 1
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3.4 在`SliverList`和`SliverGrid`中监听滚动更新事件，并计算显示比例
```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 通过ScrollViewListener捕获滚动事件
      body: ScrollViewListener(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                // 监听滚动更新事件
                return SliverMultiBoxScrollUpdateListener(
                  onScrollInit: (double percent) {
                    // percent 列表项显示比例
                  },
                  onScrollUpdate: (double percent) {
                    // percent 列表项显示比例
                  },
                  debounce: 1000,
                  // percent 列表项显示比例
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
              childCount: 6
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```