import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:my_widgets/real_state/models/message.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails(
      {super.key, required this.message, required this.entrepriseID});
  final Message message;
  final String? entrepriseID;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BlurryContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.black54),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: EColumn(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.h,
                          EText(
                            message.message,
                            color: Colors.white,
                            weight: FontWeight.w600,
                            size: 24,
                          ),
                          12.h,
                          message.contact.isNul
                              ? 0.h
                              : Center(
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle, color: Colors.green,size: 12,),
                           6.w,             EText(
                                            message.contact,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            weight: FontWeight.w600,
                                          ),
                                      GestureDetector(
                                        onTap: () {
                                          launchUrl(
                                              Uri.parse("tel:${message.contact}"));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(9),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(60)),
                                          height: 45,
                                          child: Icon(CupertinoIcons.phone, color: Colors.white,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          12.h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              EText(
                                message.date,
                                color: Colors.amber,
                              ),
                              entrepriseID.isNul
                                  ? 0.h
                                  : GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        Get.dialog(TwoOptionsDialog(
                                            confirmFunction: () async {
                                              Get.back();

                                              loading();
                                              try {
                                                await DB
                                                    .firestore(
                                                        Collections.entreprises)
                                                    .doc(entrepriseID)
                                                    .collection(
                                                        Collections.messages)
                                                    .doc(message.id)
                                                    .delete()
                                                    .then((value) {
                                                  Get.back();
                                                });
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Une erreur s'est produite");
                                                Get.back();
                                              }
                                            },
                                            body:
                                                "Voulez-vous vraiment supprimer cet avis ?",
                                            confirmationText: "Supprimer",
                                            title: "Suppression"));
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Icon(
                                            CupertinoIcons.trash,
                                            color: Colors.white,
                                          )),
                                    )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: 50,
                  width: Get.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color:
                          (categorieColors[message.categorie.toLowerCase()] ??
                              Colors.black)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 3,
                            width: 25,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.white10, Colors.white])),
                          ),
                          6.h,
                          Container(
                            height: 3,
                            width: 50,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.white10, Colors.white])),
                          )
                        ],
                      ),
                      12.w,
                      EText(
                        message.categorie,
                        weight: FontWeight.bold,
                        color: Colors.white,
                        size: 24,
                      ),
                      12.w,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 3,
                            width: 25,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.white, Colors.white10])),
                          ),
                          6.h,
                          Container(
                            height: 3,
                            width: 50,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.white,
                              Colors.white10,
                            ])),
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, Color> categorieColors = {
  "suggestion": Colors.green,
  "plainte": Colors.red,
  "idée": Color(0xff4cc9f0),
  "appréciation": Colors.teal
};
