// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:immobilier_apk/scr/ui/pages/update/update_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

bool soir = false;

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});

  var loadEnd = false.obs;
  var showLogo = false.obs;
  @override
  Widget build(BuildContext context) {
    waitAfter(555, () {
      phoneScallerFactor = MediaQuery.of(context).textScaleFactor;
      load(context);
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        EScaffold(
            color: Colors.white,
            body: Center(
              child: Obx(
                () => AnimatedOpacity(
                  duration: 333.milliseconds,
                  opacity: showLogo.value ? 1 : 0,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: 120,
                          child: EText("Fisha", size: 55, font: "Bestime" , color: Colors.amber,)),
                    ],
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: 20,
            child: Obx(
              () => AnimatedSwitcher(
                duration: 333.milliseconds,
                child: loadEnd.value || !showLogo.value
                    ? 0.h
                    : LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.color500,
                        size: 50,
                        
                      ),
              ),
            ))
      ],
    );
  }

  var awaitPrecache = [
    "bg.png",
    // "actu",
    // "announce",
    // "estimer",
    // "vendre",
    // "account_us",
    // "favoris_us",
    // "search_us",
    // "search_s",
    // "proprio_us",
    // "home_s",
    // "location"
  ];
  var noAwaitPrecache = [
    // "arrow-left",
    // "sell_locate",
    // "account_2",
    // "account_s",
    // "s_vendre",
    // "chambre",
    // "bureau",
    // "warning",
    // "connection_off",
    // "favoris_s",
    // "tri",
    // "house",
    // "terrain",
    // "style_map",
    // "boutique",
    // "star",
    // "map",
    // "search",
    // "proprio_s",
    // "notifications",
    // "maison",
    // "budget",
    // "images",
    // "empty_realStates",
    // "home_us",
    // "edit",
    // "empty_favoris",
    // "estimation",
    // "evaluate"
  ];

  void load(context) async {
    waitAfter(1200, () {
      showLogo.value = true;
    });

    if (DateTime.now().hour >= 18) {
      soir = true;
    }

    for (String element in awaitPrecache) {
      final image = Image.asset(
        Assets.image(element),
      );
      await precacheImage(image.image, context);
    }
    for (String element in noAwaitPrecache) {
      final image = Image.asset(
        Assets.icons("$element.png"),
        height: 90,
      );
      precacheImage(image.image, context);
    }

    try {
      update = await getUpdateVersion();
    } on Exception {
      // TODO
    }
    if (update.version != version) {
      Get.off(UpdatePage());
      return;
    }

    var sharp = await SharedPreferences.getInstance();
    var firstOpen = sharp.getBool('firstOpen');
    await Future.delayed(1.seconds);
    var user = FirebaseAuth.instance.currentUser;


    //text


          // 
    if (user.isNotNul) {
      if (user!.email != null) {
        await Utilisateur.getUser(user.email!);
      } else {
        await Utilisateur.getUser(user.phoneNumber!.substring(4));
      }
      waitAfter(999, () {
        Get.off(
          HomePage(),
          transition: Transition.rightToLeftWithFade,
          duration: 333.milliseconds,
        );
        sharp.setBool('firstOpen', true);

      });
    } else {
      Get.off(Connexion());
    }

    // await  getLocations(firstOpen,sharp);
  }

  // getLocations(firstOpen,sharp) async{
  //   try {
  //     // var q = await DB
  //     //     .firestore(Collections.utils)
  //     //     .doc(Collections.localites)
  //     //     .get();
  //     // Constants.localites = convertData(q.data()!);
  //     loadEnd.value = true;

  //   } on Exception {
  //     Custom.showDialog(WarningWidget(
  //         confirm: () async {
  //           getLocations(firstOpen,sharp);
  //         },
  //         message:
  //             "Une erreur s'est produite. Vérifiez votre connexion internet et réessayez svp !"));
  //     return;
  //     // TODO
  //   }
  // }
}

Map<String, Map<String, List<String>>> convertData(Map<String, dynamic> data) {
  try {
    return data.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, value.map((innerKey, innerValue) {
          if (innerValue is List<dynamic>) {
            return MapEntry(innerKey, List<String>.from(innerValue));
          } else {
            throw Exception("Invalid innerValue type");
          }
        }));
      } else {
        throw Exception("Invalid value type");
      }
    });
  } catch (e) {
    print("Error converting data: $e");
    return {};
  }
}
