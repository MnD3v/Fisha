import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';

class ViewInfos extends StatelessWidget {
  const ViewInfos({super.key});

  @override
  Widget build(BuildContext context) {
    var utilisateur = Utilisateur.currentUser.value!;
    return EScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: EText(
            "Informations",
            size: 24,
            weight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EColumn(children: [
           
        
            12.h,
            BigTitleText("Suppression de compte"),
            EText("Attention : La suppression de votre compte est définitive. Toutes vos données seront effacées et ne pourront pas être récupérées. Cette action est irréversible. Êtes-vous sûr de vouloir continuer ?"),
            12.h,
            SimpleButton(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => TwoOptionsDialog(
                        confirmFunction: () async{
                          loading();
                        await  DB.firestore(Collections.utilistateurs)
                              .doc(utilisateur.id)
                              .delete();
                              Get.back();
                              Get.off(Connexion());
                        },
                        body: "Voulez-vous vraiment supprimer ce compte",
                        confirmationText: "Supprimer",
                        title: "Suppression"));
              },
              text: "Supprimer le compte",
            )
          ]),
        ));
  }
}
