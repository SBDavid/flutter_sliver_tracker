import 'package:flutter/material.dart';

mixin ScrollSpeedMixin {
  double _pixels;
  int _timestamp;

  double velocity = 0;

  scrollSpeedEnd() {
    velocity = 0;
    _pixels = null;
    _timestamp = null;
  }

  scrollSpeedEndUpdate(ScrollUpdateNotification notification) {
    double pixels = notification.metrics.pixels;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    if (this._pixels != null && _timestamp != null) {
      velocity = (pixels - this._pixels) / (timestamp - this._timestamp);
      print(velocity);
    }
    this._pixels = pixels;
    this._timestamp = timestamp;
  }
}