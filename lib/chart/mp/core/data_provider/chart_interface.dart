import 'dart:ui';

import 'package:mp_flutter_chart/chart/mp/core/data/chart_data.dart';
import 'package:mp_flutter_chart/chart/mp/core/poolable/point.dart';
import 'package:mp_flutter_chart/chart/mp/core/value_formatter/value_formatter.dart';

mixin ChartInterface {
  /**
   * Returns the minimum x value of the chart, regardless of zoom or translation.
   *
   * @return
   */
  double getXChartMin();

  /**
   * Returns the maximum x value of the chart, regardless of zoom or translation.
   *
   * @return
   */
  double getXChartMax();

  double getXRange();

  /**
   * Returns the minimum y value of the chart, regardless of zoom or translation.
   *
   * @return
   */
  double getYChartMin();

  /**
   * Returns the maximum y value of the chart, regardless of zoom or translation.
   *
   * @return
   */
  double getYChartMax();

  /**
   * Returns the maximum distance in scren dp a touch can be away from an entry to cause it to get highlighted.
   *
   * @return
   */
  double getMaxHighlightDistance();

  MPPointF getCenterOfView(Size size);

  MPPointF getCenterOffsets();

  Rect getContentRect();

  ValueFormatter getDefaultValueFormatter();

  ChartData getData();

  int getMaxVisibleCount();
}
