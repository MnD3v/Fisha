import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/real_state/models/message.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistiques extends StatelessWidget {
  Statistiques({super.key});

  var allChartData = <List<FeedbackData>>[];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.image("bg.png")), fit: BoxFit.cover)),
      child: EScaffold(
          color: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Graphique de Feedback'),
          ),
          body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (DB.waiting(snapshot)) {
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.color500,
                      size: 50,
                    ),
                  );
                }
                return EColumn(
                    children: allChartData.map((element) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.color500,
                           ),
                        child: EText(
                          Utilisateur.currentUser.value!
                              .entreprises[allChartData.indexOf(element)].nom,
                          color: Colors.white,
                                             
                        ),
                      ),
                      Graph(chartData: element),
                    ],
                  );
                }).toList());
              })),
    );
  }

  getData() async {
    allChartData.clear();
    var entreprises = Utilisateur.currentUser.value!.entreprises
        .map((toElement) => toElement.id)
        .toList();

    for (var element in entreprises) {
      var q = await DB
          .firestore(Collections.entreprises)
          .doc(element)
          .collection(Collections.messages)
          .get();
      var data = {
        "Suggestion": 0,
        "Plainte": 0,
        "Idée": 0,
        "Appréciation": 0,
      };
      for (var e in q.docs) {
        var msg = Message.fromMap(e.data());
        data[msg.categorie] = data[msg.categorie]! + 1;
      }

      var chartData = data.keys.map((element) {
        return FeedbackData(element, data[element]!);
      }).toList();

      allChartData.add(chartData);
    }
  }
}

class Graph extends StatelessWidget {
  Graph({super.key, required this.chartData});
  final List<FeedbackData> chartData;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            dataSource: chartData,
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
            explodeIndex: 1,
          )
        ],
        // backgroundColor: Colors.black.withOpacity(0.1),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

class FeedbackData {
  FeedbackData(this.category, this.value);
  final String category;
  final int value;
}
