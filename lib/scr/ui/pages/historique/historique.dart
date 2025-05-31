import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/real_state/models/rechargement.dart';
import 'package:my_widgets/real_state/models/vente.dart';

class HistoriqueRechargements extends StatelessWidget {
  const HistoriqueRechargements({super.key});

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        title: BigTitleText("Historique"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: StreamBuilder(
        stream: DB
            .firestore(Collections.rechargements)
            .doc("Tilapia")
            .collection(Collections.historique)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ECircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return EError();
          }
          var rechargements = <Rechargement>[];

          for (var element in snapshot.data!.docs) {
            rechargements.add(Rechargement.fromMap(element.data()));
          }

          return ListView(
            children: rechargements
                .map((element) => Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(21)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_outward_outlined,
                            size: 30,
                          ),
                          12.w,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EText(
                                "${element.quantite}kg",
                                size: 55,
                                font: "Bestime",
                                color: Colors.amber,
                              ),
                              EText(element.date
                                  .split(" ")[0]
                                  .split("-")
                                  .reversed
                                  .join("-"))
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Custom.showDialog(RechargementPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class RechargementPage extends StatelessWidget {
  RechargementPage({super.key});

  var quantite = 0.0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: EColumn(
            children: [
              BigTitleText("Rechargement"),
              12.h,
              EText("Quantité"),
              ETextField(
                phoneScallerFactor: phoneScallerFactor,
                onChanged: (value) {
                  quantite = double.parse(value);
                },
              ),
              12.h,
              SimpleButton(
                onTap: () async {
                  if (quantite > 0) {
                    Get.back();
                    loading();
                    var id = DateTime.now().millisecondsSinceEpoch.toString();
                    await DB
                        .firestore(Collections.rechargements)
                        .doc("Tilapia")
                        .collection(Collections.historique)
                        .add(Rechargement(
                                id: id,
                                date: DateTime.now().toString(),
                                quantite: quantite)
                            .toMap());
          
                    await DB
                        .firestore(Collections.rechargements)
                        .doc("Tilapia")
                        .update({"stock_actuel": FieldValue.increment(quantite)});
          
                    Get.back();
                    Toasts.success(context,
                        description: "Rechargement effectué avec succès");
                  } else {
                    Toasts.error(context,
                        description: "Veuillez entrer une quantité valide");
                  }
                },
                text: "Recharger",
              )
            ],
          ),
        ),
      ),
    );
  }
}
