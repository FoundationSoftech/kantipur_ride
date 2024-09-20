import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/dt_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OrdersBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Total Orders',
            alignment: ChartAlignment.near,
            textStyle: GoogleFonts.openSans(
          fontSize: 20.sp,
          color: AppColors.primaryColor,

        )),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(color: Colors.blue),
        ),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 12000,
          interval: 3000,
        ),
        series: <CartesianSeries>[
          // Blue portion (actual values)
          StackedColumnSeries<_ChartData, String>(
            dataSource: [
              _ChartData('Bike', 10000),
              _ChartData('Car', 4000),
              _ChartData('Taxi', 8000),
            ],
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: AppColors.purpleColor,
            name: 'value',
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
          // Grey portion (remaining values)
          StackedColumnSeries<_ChartData, String>(
            dataSource: [
              _ChartData('Bike', 2000),
              _ChartData('Car', 8000),
              _ChartData('Taxi', 4000),
            ],
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => 12000 ,
            color: Colors.grey[300],
            name: 'Remaining',
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
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
