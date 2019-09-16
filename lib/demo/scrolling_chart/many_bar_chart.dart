import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_flutter_chart/chart/mp/chart/bar_chart.dart';
import 'package:mp_flutter_chart/chart/mp/core/data/bar_data.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_flutter_chart/chart/mp/core/description.dart';
import 'package:mp_flutter_chart/chart/mp/core/entry/bar_entry.dart';
import 'package:mp_flutter_chart/chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_flutter_chart/chart/mp/core/utils/color_utils.dart';
import 'package:mp_flutter_chart/demo/util.dart';

class ScrollingChartManyBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollingChartManyBarState();
  }
}

class ScrollingChartManyBarState extends State<ScrollingChartManyBar> {
  List<BarData> _barDatas = List();

  var random = Random(1);

  bool _isParentMove = true;
  double _curX = 0.0;
  int _preTime = 0;

  @override
  void initState() {
    _initBarDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Scrolling Chart Many Bar")),
        body: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              bottom: 0,
              child: Listener(
                onPointerDown: (e) {
                  _curX = e.localPosition.dx;
                  _preTime = Util.currentTimeMillis();
                },
                onPointerMove: (e) {
                  if (_preTime + 500 < Util.currentTimeMillis()) {
                    if ((_curX - e.localPosition.dx) < 5) {
                      _isParentMove = false;
                      if (mounted) {
                        setState(() {});
                      }
                    }
                  }
                },
                onPointerUp: (e) {
                  if (!_isParentMove) {
                    _isParentMove = true;
                    if (mounted) {
                      setState(() {});
                    }
                  }
                },
                child: ListView.builder(
                    itemCount: _barDatas.length,
                    itemBuilder: (context, index) {
                      return _renderItem(index);
                    },
                    physics: _isParentMove
                        ? PageScrollPhysics()
                        : NeverScrollableScrollPhysics()),
              ),
            ),
          ],
        ));
  }

  Widget _renderItem(int index) {
    var data = _barDatas[index];

    var desc = Description();
    desc.setEnabled(false);
    return Container(
        height: 200,
        child: BarChart(data, (painter) {
          painter..setFitBars(true);
          painter.mAxisLeft
            ..setLabelCount2(5, false)
            ..setSpaceTop(15);
          painter.mAxisRight
            ..setLabelCount2(5, false)
            ..setSpaceTop(15);

          painter.mXAxis
            ..setPosition(XAxisPosition.BOTTOM)
            ..setDrawGridLines(false);

          painter.mAnimator.animateY1(700);
        },
            touchEnabled: true,
            drawGridBackground: false,
            dragXEnabled: true,
            dragYEnabled: true,
            scaleXEnabled: true,
            scaleYEnabled: true,
            desc: desc));
  }

  void _initBarDatas() {
    _barDatas.clear();
    for (int i = 0; i < 20; i++) {
      _barDatas.add(generateData(i + 1));
    }
  }

  BarData generateData(int cnt) {
    List<BarEntry> entries = List();

    for (int i = 0; i < 12; i++) {
      entries
          .add(BarEntry(x: i.toDouble(), y: (random.nextDouble() * 70) + 30));
    }

    BarDataSet d = BarDataSet(entries, "New DataSet $cnt");
    d.setColors1(ColorUtils.VORDIPLOM_COLORS);
    d.setBarShadowColor(Color.fromARGB(255, 203, 203, 203));

    List<IBarDataSet> sets = List();
    sets.add(d);

    BarData cd = BarData(sets);
    cd.setBarWidth(0.9);
    return cd;
  }
}
