import 'package:flutter/widgets.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';

class Formations extends StatelessWidget {
  const Formations(
      {super.key,
      required this.illustration,
      required this.description,
      required this.title});
  final String illustration;
  final String description;
  final String title;
  @override
  Widget build(BuildContext context) {
    return EScaffold(
        floatingActionButton:
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: IconButton(onPressed: () {
                Get.back();
              }, icon: Icon(Icons.arrow_back)),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: EColumn(children: [
          Image.asset(
            Assets.image(illustration),
            width: Get.width,
            height: Get.height * .3,
          ),
          BigTitleText("Tutoriel"),
          Column(
            children: tutorielsSexuels
                .map((element) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS83AYFUnFB09Lxe4aIH1jRnRoCfqcC9k9L0g&s")),
                                borderRadius: BorderRadius.circular(12)),
                            child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: Get.width - 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigTitleText(element['titre'],
                                    color: AppColors.color500, maxLines: 1),
                                EText(
                                  element['description'],
                                  maxLines: 2,
                                ),
                                EText(
                                  DateTime.now().toString().split(" ")[0],
                                  size: 16,
                                  color: const Color.fromARGB(255, 234, 141, 0),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          )
        ]));
  }
}

final List<Map<String, dynamic>> tutorielsSexuels = [
  {
    'titre': 'Comprendre son corps',
    'image': 'https://example.com/images/corps.png',
    'description':
        'Une introduction aux bases de l’anatomie sexuelle pour mieux se connaître.',
    'duree': '8:32'
  },
  {
    'titre': 'Hygiène intime : les bonnes pratiques',
    'image': 'https://example.com/images/hygiene.png',
    'description':
        'Conseils pour une hygiène intime saine chez les hommes et les femmes.',
    'duree': '6:45'
  },
  {
    'titre': 'Le consentement expliqué simplement',
    'image': 'https://example.com/images/consentement.png',
    'description':
        'Ce qu’est le consentement, pourquoi c’est essentiel, et comment l’exprimer.',
    'duree': '5:20'
  },
  {
    'titre': 'Les IST : prévention et dépistage',
    'image': 'https://example.com/images/ist.png',
    'description':
        'Comprendre les infections sexuellement transmissibles et comment s’en protéger.',
    'duree': '10:14'
  },
  {
    'titre': 'Premiers rapports : être prêt(e)',
    'image': 'https://example.com/images/premier_rapport.png',
    'description':
        'Conseils pour aborder ses premières expériences sexuelles en confiance.',
    'duree': '7:58'
  },
  {
    'titre': 'Contraception : quelles options ?',
    'image': 'https://example.com/images/contraception.png',
    'description':
        'Présentation des méthodes contraceptives disponibles et leur efficacité.',
    'duree': '9:03'
  },
  {
    'titre': 'Cycle menstruel et sexualité',
    'image': 'https://example.com/images/cycle.png',
    'description':
        'Comprendre le cycle menstruel et son impact sur la sexualité.',
    'duree': '6:30'
  },
  {
    'titre': 'Mythes et réalités sur le sexe',
    'image': 'https://example.com/images/mythes.png',
    'description': 'Démystification des idées reçues sur la sexualité.',
    'duree': '11:11'
  },
  {
    'titre': 'Le respect dans la relation',
    'image': 'https://example.com/images/respect.png',
    'description': 'Comment instaurer une relation saine et respectueuse.',
    'duree': '7:15'
  },
  {
    'titre': 'Le plaisir sexuel : en parler sans tabou',
    'image': 'https://example.com/images/plaisir.png',
    'description':
        'Aborder librement la question du plaisir sexuel et de la communication.',
    'duree': '8:48'
  },
];
