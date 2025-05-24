import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class PieChartPage extends StatefulWidget {
  const PieChartPage({Key? key}) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  late List<FeedbackData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphique de Feedback'),
      ),
      body: Center(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(10),
          child: SfCircularChart(
            title: ChartTitle(text: 'Analyse des Feedbacks'),
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
            ),
            series: <CircularSeries>[
              PieSeries<FeedbackData, String>(
                dataSource: _chartData,
                xValueMapper: (FeedbackData data, _) => data.category,
                yValueMapper: (FeedbackData data, _) => data.value,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  connectorLineSettings: ConnectorLineSettings(
                    type: ConnectorType.curve,
                    length: '15%',
                  ),
                ),
                enableTooltip: true,
                explode: true,
                explodeIndex: 0,
              )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ),
    );
  }

  List<FeedbackData> getChartData() {
    final List<FeedbackData> chartData = [
      FeedbackData('Suggestions', 4),
      FeedbackData('Plaintes', 6),
      FeedbackData('Idées', 2),
      FeedbackData('Appréciations', 9),
    ];
    return chartData;
  }
}

class FeedbackData {
  FeedbackData(this.category, this.value);
  final String category;
  final int value;
}