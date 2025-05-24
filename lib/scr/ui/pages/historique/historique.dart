import 'package:flutter/widgets.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/real_state/models/vente.dart';

class Historique extends StatelessWidget {
  const Historique({super.key});

  @override
  Widget build(BuildContext context) {
    return EScaffold(
        appBar: AppBar(
          title: BigTitleText("Historique"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(onPressed: (){
            Get.back();
          }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        ),
        body: FutureBuilder(
          future: DB.firestore(Collections.historique).orderBy("date", descending: true).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ECircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return EError();
            }
            var ventes = <Vente>[];

            for (var element in snapshot.data!.docs) {
              ventes.add(Vente.fromMap(element.data()));
            }

            return ListView(
              children: ventes
                  .map((element) => Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(
                      color: Colors.black12
                    ), borderRadius: BorderRadius.circular(21)),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_outward_outlined, size: 30,),
                        12.w,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EText("${element.nombreKg}kg", size: 55, font: "Bestime", color: Colors.amber,),
                            EText(element.date.split(" ")[0].split("-").reversed.join("-"))
                          ],
                        ),
                      ],
                    ),
                  ))
                  .toList(),
            );
          },
        ));
  }
}
