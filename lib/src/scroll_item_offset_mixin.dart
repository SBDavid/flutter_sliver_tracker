import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 计算滑动元素的曝光范围
mixin ScrollItemOffsetMixin {
  // 滑块起始位置距离视窗起始位置的距离
  double itemStartOffset;
  // itemStartOffset + 滑块长度
  double itemEndOffset;
  // 与视窗切割
  double itemStartOffsetClamp;
  double itemEndOffsetClamp;
  double paintExtent;

  void calculateDisplayPercent(BuildContext context, double topOverlapCompensation, double bottomOverlapCompensation) {

    if (context == null) {
      paintExtent = 0;
      return;
    }

    // RenderSliverList
    RenderSliverMultiBoxAdaptor renderSliverMultiBoxAdaptor = context.findAncestorRenderObjectOfType();
    // ScrollView的起始绘制位置
    double startOffset = renderSliverMultiBoxAdaptor.constraints.scrollOffset;
    // ScrollView的结束绘制位置
    double endOffset = startOffset + renderSliverMultiBoxAdaptor.geometry.paintExtent;
    // 主轴方向
    Axis axis = renderSliverMultiBoxAdaptor.constraints.axis;
    paintExtent = renderSliverMultiBoxAdaptor.geometry.paintExtent;

    // 如果还没有显示到Viewport中
    if (endOffset < 0.00001) {
      paintExtent = 0;
      return;
    }

    // 当前item相对于列表起始位置的偏移 SliverLogicalParentData
    double itemLayoutOffset = 0;
    Size itemSize;
    context.visitAncestorElements((element) {
      if (element.renderObject == null) {
        return true;
      }

      if (element.renderObject.parentData == null) {
        return true;
      }

      if (!(element.renderObject.parentData is SliverLogicalParentData)) {
        return true;
      }

      itemLayoutOffset = (element.renderObject.parentData as SliverLogicalParentData).layoutOffset;
      itemSize = (element.renderObject as RenderBox).size;

      itemStartOffset = itemLayoutOffset;
      itemEndOffset = axis == Axis.vertical ? itemStartOffset + itemSize.height : itemStartOffset + itemSize.width;
      itemStartOffsetClamp = itemStartOffset.clamp(startOffset+topOverlapCompensation, endOffset-bottomOverlapCompensation);
      itemEndOffsetClamp = itemEndOffset.clamp(startOffset+topOverlapCompensation, endOffset-bottomOverlapCompensation);

      return false;
    });
  }
}