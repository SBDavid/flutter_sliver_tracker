# flutter_sliver_tracker

滑动曝光埋点框架，支持SliverList、SliverGrid，以及嵌套的情况（详见example2/SliverMultiBoxScrollListenerDebounceDemo）

## 什么是滑动曝光埋点

滑动曝光埋点用于滑动列表组件中的模块曝光，例如Flutter中的`SliverList`、`SliverGrid`。
当`SliverList`中的某一个行（或列）移动到`ViewPort`中，并且显示比例超过一定阈值时，我们把这个事件记为一次滑动曝光事件。

当然我们对滑动曝光有一些额外的要求：
- 需要滑出一定比例的时候才出发曝光（已实现）
- 滑动速度快时不触发曝光事件（已实现）
- 滑出视野的模块，再次滑入视野时需要再次上报（已实现）
- 模块在视野中上下反复移动只触发一次曝光（已实现）
- 嵌套情况：支持滑动组件相互全套（已实现）
    - SliverMultiBoxScrollListener已支持嵌套
    - SliverMultiBoxScrollListenerDebounce已支持嵌套
    - SliverScrollListener不支持，请使用SliverMultiBoxScrollListener
    - SliverScrollListenerDebounce不支持，请使用SliverMultiBoxScrollListenerDebounce
    - 所有嵌套情况只测试过两层嵌套，理论上支持更多层。

## 运行Demo
<img src="https://raw.githubusercontent.com/SBDavid/flutter_sliver_tracker/master/demo.gif" width="270" height="480" alt="图片名称">

- 克隆代码到本地: git clone git@github.com:SBDavid/flutter_sliver_tracker.git
- 切换工作路径: cd flutter_sliver_tracker/example/
- 启动模拟器
- 运行: flutter run

## 内部原理

滑动曝光的核心难点是计算组件的露出比例。也是说我们需要知道`ListView`中的组件的`总高度`、`当前显示高度`。
这两个高度做除法就可以得出比例。

### 组件总高度
组件的总高度可以在`renderObject`中获取。我们可以获取`renderObject`下的`size`属性，其中包含了组件的长宽。

### 当前显示高度
显示高度可以从`SliverGeometry.paintExtent`中获取。

## 使用文档
### 1. 安装

```yaml
dependencies:
  flutter_sliver_tracker: ^1.0.0
```

### 2. 引用插件
```dart
import 'package:xm_sliver_listener/flutter_sliver_tracker.dart';
```

### 3. 发送滑动埋点事件

#### 3.1 通过`ScrollViewListener`捕获滚动事件，`ScrollViewListener`必须包裹在`CustomScrollView`之上。

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

#### 3.2 在`SliverToBoxAdapter`中监听滚动停止事件，并计算显示比例
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

#### 3.3 在`SliverList`和`SliverGrid`中监听滚动停止事件，并计算显示比例

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

#### 3.4 在`SliverList`和`SliverGrid`中监听滚动更新事件，并计算显示比例
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