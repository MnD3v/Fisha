import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/widgets/message_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/real_state/models/entreprise.dart';
import 'package:my_widgets/real_state/models/message.dart';

class Messages extends StatefulWidget {
  Messages({super.key, required this.currentEntreprise});
  final RealEntreprise currentEntreprise;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var messages = (<Message>[]).obs;

  var inView = false.obs;

  var categories = <String>[].obs;
  var sieges = <String>[].obs;

  var tousLesCategories = ["Suggestion", "Plainte", "Idée", "Appréciation"];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      waitAfter(333, () {
        inView.value = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DB
          .firestore(Collections.entreprises)
          .doc(widget.currentEntreprise.id)
          .collection(Collections.messages)
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<Message> tempMessages = [];
        if (snapshot.hasData) {
          print("has data");

          snapshot.data!.docs.forEach((element) {
            print("added");
            var msg = Message.fromMap(element.data());
            msg.id = element.id;
            tempMessages.add(msg);
          });
        }

        messages.value = tempMessages;
        categories.value = [...tousLesCategories];
        sieges.value = [...widget.currentEntreprise.sieges];

        if (snapshot.connectionState == ConnectionState.done) {
          print(messages.length);
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.color500,
                    size: 40,
                  ),
                )
              : Obx(
                  () => messages.isEmpty
                      ? Center(
                          key: Key("empty"),
                          child: Image.asset(
                            Assets.icons("empty.png"),
                            height: 120,
                          ))
                      : ListView.builder(
                          key: Key(messages.length.toString()),
                          physics: BouncingScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var element = messages[index];

                            return Obx(
                              () => AnimatedOpacity(
                                duration: (333 * index + 333).milliseconds,
                                opacity: inView.value ? 1 : 0,
                                child: AnimatedPadding(
                                  duration: (333 * index + 333).milliseconds,
                                  padding: EdgeInsets.only(
                                      top: inView.value ? 0 : 20),
                                  child: Column(
                                    children: [
                                      (index != 0 &&
                                              messages[index]
                                                      .date
                                                      .split(" ")[0] ==
                                                  messages[index - 1]
                                                      .date
                                                      .split(" ")[0])
                                          ? 0.h
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  top: index == 0 ? 9 : 0),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: const Color.fromARGB(
                                                      255, 224, 224, 224)),
                                              child: EText(
                                                theDate(element),
                                                size: 16,
                                                color: const Color.fromARGB(
                                                    255, 43, 43, 43),
                                              ),
                                            ),
                                      GestureDetector(
                                        onTap: () {
                                          Custom.showDialog(MessageDetails(
                                            message: element,
                                            entrepriseID:
                                                widget.currentEntreprise.id,
                                          ));
                                        },
                                        child: MessageCard(element: element),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              filtrer(tempMessages);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Assets.icons("filtrer.png"), height: 25),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> filtrer(tempMessages) {
    return Get.bottomSheet(
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.all(9),
          child: Obx(
            () => EColumn(children: [
              widget.currentEntreprise.sieges.length < 2
                  ? 0.h
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.h,
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: EText(
                            "Sièges",
                            size: 28,
                            weight: FontWeight.bold,
                          ),
                        ),
                        ...widget.currentEntreprise.sieges.map((element) {
                          return CheckboxListTile(
                            value: sieges.contains(element),
                            onChanged: (value) {
                              if (!sieges.contains(element)) {
                                sieges.add(element);
                              } else {
                                sieges.remove(element);
                              }
                            },
                            title: EText(element),
                          );
                        }),
                      ],
                    ),
              12.h,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: EText(
                  "Categories",
                  size: 28,
                  weight: FontWeight.bold,
                ),
              ),
              ...tousLesCategories.map((element) {
                return CheckboxListTile(
                  value: categories.contains(element),
                  onChanged: (value) {
                    if (!categories.contains(element)) {
                      categories.add(element);
                    } else {
                      categories.remove(element);
                    }
                  },
                  title: EText(element),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleButton(
                  radius: 12,
                  onTap: () {
                    Get.back();
                    waitAfter(333, () {
                      messages.value = tempMessages
                          .where((element) =>
                              categories.contains(element.categorie))
                          .toList();

                      if (widget.currentEntreprise.sieges.length > 2) {
                        messages.value = messages
                            .where((element) => sieges.contains(element.siege))
                            .toList();
                      }
                    });
                  },
                  text: "Continuer",
                ),
              ),
            ]),
          ),
        ),
        isScrollControlled: true);
  }

  String theDate(Message element) {
    return GFunctions.isToday(element.date.split(" ")[0])
        ? "Aujourd'hui"
        : GFunctions.isYesterday(element.date.split(" ")[0])
            ? "Hier"
            : element.date.split(" ")[0].split("-").reversed.join("-");
  }
}

Map<String, Color> categorieColors = {
  "suggestion": Colors.green,
  "plainte": Colors.red,
  "idée": Color(0xff4cc9f0),
  "appréciation": Colors.teal
};
