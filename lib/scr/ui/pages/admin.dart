import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/real_state/models/vente.dart';
import 'package:universal_html/html.dart';

import '../../config/app/export.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final RxList<int> _selectedDates = RxList<int>();

  void _onDateTap(int indexDate) {
    print(indexDate);
    if (_selectedDates.contains(indexDate)) {
      _selectedDates.remove(indexDate); // Annule la sélection
    } else {
      if (_selectedDates.length == 2) {
        _selectedDates.clear(); // Reset si déjà 2 dates sélectionnées
      }
      _selectedDates.add(indexDate);
    }

    // Tu peux maintenant utiliser _selectedDates pour faire des opérations
    if (_selectedDates.length == 2) {
      final debut = _selectedDates[0];
      final fin = _selectedDates[1];
      // Fait ce que tu veux ici avec l'intervalle
      print("Intervalle sélectionné : $debut → $fin");
    } else if (_selectedDates.length == 1) {
      print("Date sélectionnée : ${_selectedDates[0]}");
    }
  }

  var jours = <String>[];

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: EText(
          "Fisha",
          font: "Bestime",
          size: 66,
          color: Colors.amber,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DB.firestore(Collections.ventes).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ECircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return EError();
          }

          for (var element in snapshot.data!.docs) {
            jours.add(element.data()["date"]);
          }

          return Obx(
            () => Wrap(
              children: jours.map((element) {
                String date = element;
                bool isSelected = _selectedDates.contains(jours.indexOf(date));
                return GestureDetector(
                  onTap: () => _onDateTap(jours.indexOf(date)),
                  child: Container(
                    margin: const EdgeInsets.all(9),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.2) : null,
                      border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => _selectedDates.isEmpty
            ? 0.h
            : SimpleButton(
                radius: 9,
                onTap: () async {
                loading();
                  var ventes = <Vente>[];
                  for (var i = getMin(_selectedDates);
                      i <= getMax(_selectedDates);
                      i++) {
                    var q = await DB
                        .firestore(Collections.ventes)
                        .doc(jours[i])
                        .collection(Collections.ventes)
                        .get();
                    var _ventes =
                        q.docs.map((element) => Vente.fromMap(element.data()));
                    ventes.addAll(_ventes);
                  }
                  List<List<dynamic>> rows = [
                    [
                      "Heure",
                      "Date",
                      "Kilogrammes",
                      "Prix Total",
                    ], // En-tête
                    for (var vente in ventes)
                      [
                        vente.date.split(" ")[1].split(".")[0],
                        vente.date.split(" ")[0],
                        vente.nombreKg,
                        "${(vente.nombreKg * 800).toInt()} XOF",
                      ]
                  ];

                  // Convertit les lignes en contenu CSV
                  String csvContent = const ListToCsvConverter().convert(rows);

                  // Encode en UTF-8 pour obtenir des octets
                  final bytes = utf8.encode(csvContent);

                  // Crée un blob avec les octets
                  final blob = Blob([bytes], 'text/csv;charset=utf-8');
                  final url = Url.createObjectUrlFromBlob(blob);

                  // Crée un lien de téléchargement
                  final anchor = AnchorElement(href: url)
                    ..target = 'blank'
                    ..download = _selectedDates.length < 2
                        ? 'vente_${jours[_selectedDates[0]]}.csv'
                        : 'vente_${jours[_selectedDates[0]]} - ${jours[_selectedDates[1]]}.csv'
                    ..click();

                  // Nettoie l'URL après le téléchargement
                  Url.revokeObjectUrl(url);
                  Get.back();
                },
                text: "Telecharger",
              )),
      ),
    );
  }
}

int getMax(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError('La liste est vide');
  }
  int max = numbers[0];
  for (int number in numbers) {
    if (number > max) {
      max = number;
    }
  }
  return max;
}

int getMin(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError('La liste est vide');
  }
  int min = numbers[0];
  for (int number in numbers) {
    if (number < min) {
      min = number;
    }
  }
  return min;
}
