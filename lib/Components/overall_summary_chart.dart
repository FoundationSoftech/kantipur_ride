import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/dt_colors.dart';
import 'package:google_fonts/google_fonts.dart';


class SummaryChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: Offset(0, 5),
          ),
        ],
      ),
          child: SfCircularChart(
            title: ChartTitle(
                text: 'Overall Summary',
                alignment: ChartAlignment.near,
                textStyle: GoogleFonts.openSans(

                  fontSize: 20.sp,
                  color: AppColors.primaryColor,

                )),
            legend: Legend(isVisible: false),
            series: <PieSeries<_ChartData, String>>[
              PieSeries<_ChartData, String>(
                dataSource: [
                  _ChartData('Segment 1', 3543),
                  _ChartData('Segment 2', 8543),
                  _ChartData('Segment 3', 10543),
                ],
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                pointColorMapper: (_ChartData data, _) => AppColors.primaryColor,
                dataLabelMapper: (_ChartData data, _) => data.y.toString(),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(fontSize: 12.sp, color: AppColors.primaryColor),
                ),
                explode: true,
                explodeAll: true,
                explodeIndex: 0,
                explodeOffset: '2%',
              )
            ],
          ),
        );

  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

