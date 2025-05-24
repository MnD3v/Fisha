import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/connexion.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                child: Image(
                    image: AssetImage(Assets.image('update.png')),
                    fit: BoxFit.contain)),
            24.h,
            EText(
              "Une mise à jour est disponible !",
              size: 25,
              color: AppColors.color500,
              weight: FontWeight.w900,
            ),
            12.h,
            const EText(
              "Votre application est actuellement obsolète. Veuillez télécharger la dernière mise à jour disponible.",
              // size: 22,
              align: TextAlign.center,
              maxLines: 12,
            ),
            6.h,
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: "Taille de télechargement: "),
                TextSpan(
                    text: "5,7 Mo ",
                    style: TextStyle(
                        color: AppColors.color500, fontWeight: FontWeight.bold))
              ]),
              textScaleFactor: .7,
            ),
            12.h,
            SimpleButton(
              height: 45,
              width: Get.width / 2,
              onTap: () async {
                loading();
                var q = await DB.firestore(Collections.keys).doc('update').get();

                var update = Update.fromMap(q.data()!);
                Get.back();
                launchUrl(Uri.parse(
                    update.link??'https://play.google.com/store/apps/details?id=com.equilibre.sboite'));
              },
              text: 'Telecharger',
            ),
            6.h,
            update.optionel == true
                ? SimpleButton(
                    height: 46,
                    color: Colors.black26,
                    width: Get.width / 2,
                    onTap: () async {
                      loading();
                      var sharp = await SharedPreferences.getInstance();
                      var firstOpen = sharp.getBool('firstOpen');
                      await Future.delayed(1.seconds);
                      var user = FirebaseAuth.instance.currentUser;
                      if (user.isNotNul) {
                        if (user!.email != null) {
                          await Utilisateur.getUser(user.email!);
                        } else {
                          await Utilisateur.getUser(
                              user.phoneNumber!.substring(4));
                        }
                        await Utilisateur.refreshToken();
                        waitAfter(999, () {
                          Get.back();
                          Get.off(
                            HomePage(),
                            transition: Transition.rightToLeftWithFade,
                            duration: 333.milliseconds,
                          );
                          sharp.setBool('firstOpen', true);
                       
                        });
                      } else {
                          Get.back();

                        Get.off(Connexion());
                      }
                    },
                    child: EText('Plus tard',
                        weight: FontWeight.normal, color: Colors.black),
                  )
                : 0.h
          ],
        ),
      ),
    );
  }
}
