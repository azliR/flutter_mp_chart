import 'package:mp_flutter_chart/chart/mp/core/buffer/abstract_buffer.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/entry/bar_entry.dart';

class BarBuffer extends AbstractBuffer<IBarDataSet> {
  int mDataSetIndex = 0;
  int mDataSetCount = 1;
  bool mContainsStacks = false;
  bool mInverted = false;

  /** width of the bar on the x-axis, in values (not pixels) */
  double mBarWidth = 1.0;

  BarBuffer(int size, int dataSetCount, bool containsStacks) : super(size) {
    this.mDataSetCount = dataSetCount;
    this.mContainsStacks = containsStacks;
  }

  void setBarWidth(double barWidth) {
    this.mBarWidth = barWidth;
  }

  void setDataSet(int index) {
    this.mDataSetIndex = index;
  }

  void setInverted(bool inverted) {
    this.mInverted = inverted;
  }

  void addBar(double left, double top, double right, double bottom) {
    buffer[index++] = left;
    buffer[index++] = top;
    buffer[index++] = right;
    buffer[index++] = bottom;
  }

  @override
  void feed(IBarDataSet data) {
    double size = data.getEntryCount() * phaseX;
    double barWidthHalf = mBarWidth / 2.0;

    for (int i = 0; i < size; i++) {
      BarEntry e = data.getEntryForIndex(i);

      if (e == null) continue;

      double x = e.x;
      double y = e.y;
      List<double> vals = e.getYVals();

      if (!mContainsStacks || vals == null) {
        double left = x - barWidthHalf;
        double right = x + barWidthHalf;
        double bottom, top;

        if (mInverted) {
          bottom = y >= 0 ? y : 0;
          top = y <= 0 ? y : 0;
        } else {
          top = y >= 0 ? y : 0;
          bottom = y <= 0 ? y : 0;
        }

        // multiply the height of the rect with the phase
        if (top > 0)
          top *= phaseY;
        else
          bottom *= phaseY;

        addBar(left, top, right, bottom);
      } else {
        double posY = 0.0;
        double negY = -e.getNegativeSum();
        double yStart = 0.0;

        // fill the stack
        for (int k = 0; k < vals.length; k++) {
          double value = vals[k];

          if (value == 0.0 && (posY == 0.0 || negY == 0.0)) {
            // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
            y = value;
            yStart = y;
          } else if (value >= 0.0) {
            y = posY;
            yStart = posY + value;
            posY = yStart;
          } else {
            y = negY;
            yStart = negY + value.abs();
            negY += value.abs();
          }

          double left = x - barWidthHalf;
          double right = x + barWidthHalf;
          double bottom, top;

          if (mInverted) {
            bottom = y >= yStart ? y : yStart;
            top = y <= yStart ? y : yStart;
          } else {
            top = y >= yStart ? y : yStart;
            bottom = y <= yStart ? y : yStart;
          }

          // multiply the height of the rect with the phase
          top *= phaseY;
          bottom *= phaseY;

          addBar(left, top, right, bottom);
        }
      }
    }
    reset();
  }
}