import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/ui/pages/home_page.dart';
import 'package:immobilier_apk/scr/ui/pages/signIn/inscription.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_widgets/my_widgets.dart';
import 'package:my_widgets/widgets/scaffold.dart';

// ignore: must_be_immutable
class Connexion extends StatelessWidget {
  Connexion({
    super.key,
  });
  String telephone = '';

  String pass = '';

  var passvisible = false.obs;

  var isLoading = false.obs;

  var country = "TG";

  @override
  Widget build(BuildContext context) {
    var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
       decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.image("bg.png")), fit: BoxFit.cover)),
      child: BlurryContainer(
        decoration: BoxDecoration(color: Colors.black26),
        child: EScaffold(
          color: Colors.transparent,
      
          body: Obx(
            () => IgnorePointer(
              ignoring: isLoading.value,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: EColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                   Image.asset(Assets.icons("launch_icon.png"), height: 90,),
                        25.h,
                        EText(
                          'Connectez-vous',
                          color: Colors.white,
                          size: 32,
                          weight: FontWeight.bold,
                        ),
                        18.h,
                        UnderLineTextField(
                            color: Colors.white30,

                          textColor: Colors.white,
                          phoneScallerFactor: phoneScallerFactor,
                          prefix: ChooseCountryCode(
                            onChanged: (value) {},
                          ),
                          label: "Numero de téléphone",
                          onChanged: (value) {
                            telephone = value;
                          },
                          number: true,
                        ),
                        12.h,
                        Obx(
                          () => UnderLineTextField(
                            color: Colors.white30,
                          textColor: Colors.white,

                            phoneScallerFactor: phoneScallerFactor,
                            initialValue: pass,
                            onChanged: (value) {
                              pass = value + "00";
                            },
                            pass: passvisible.value ? false : true,
                            label: "Mot de passe",
                            suffix: GestureDetector(
                              onTap: () {
                                passvisible.value = !passvisible.value;
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 9.0),
                                child: Icon(
                                    passvisible.value
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye_fill,
                                    color: AppColors.textColor),
                              ),
                            ),
                          ),
                        ),
                        24.h,
                        SimpleButton(
                            width: Get.width,
                            color: Colors.amber,
                            radius: 9,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (!GFunctions.isPhoneNumber(
                                  country: country, numero: telephone)) {
                                Toasts.error(context,
                                    description: "Entrez un numero valide");
                                return;
                              }
                              if (pass.length < 6) {
                                Toasts.error(context,
                                    description:
                                        "Le mot de passe doit contenir aumoins 6 caracteres");
                                return;
                              }
        
                              isLoading.value = true;
                              try {
                                var q = await DB
                                    .firestore(Collections.utilistateurs)
                                    .doc(telephone)
                                    .get();
                                if (q.exists) {
                                  var utilisateur = Utilisateur.fromMap(q.data()!);
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: "$telephone@gmail.com",
                                            password: pass);
                                    Utilisateur.currentUser.value = utilisateur;
        
                                    isLoading.value = false;
        
                                    Get.off(HomePage());
                                    Toasts.success(context,
                                        description:
                                            "Vous vous êtes connecté avec succès");
                                    Utilisateur.refreshToken();
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == "network-request-failed") {
                                      isLoading.value = false;
        
                                      Custom.showDialog(const WarningWidget(
                                        message:
                                            'Echec de connexion.\nVeuillez verifier votre connexion internet',
                                      ));
                                    } else if (e.code == 'invalid-credential') {
                                      isLoading.value = false;
        
                                      Custom.showDialog(const WarningWidget(
                                        message: 'Mot de passe incorrect',
                                      ));
                                    }
                                  }
                                } else {
                                  isLoading.value = false;
                                  Custom.showDialog(
                                    const WarningWidget(
                                      message:
                                          'Pas de compte associé à ce numero. Veuillez creer un compte',
                                    ),
                                  );
                                }
                              } on Exception {
                                isLoading.value = false;
                                Custom.showDialog(const WarningWidget(
                                  message:
                                      "Une erreur s'est produite. veuillez verifier votre connexion internet",
                                ));
                              }
                            },
                            child: Obx(
                              () => isLoading.value
                                  ? LoadingAnimationWidget.threeRotatingDots(
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const EText(
                                      'Me connecter',
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                            )),
                        // TextButton(
                        //   onPressed: () {
                        //     forgotPassword(context);
                        //   },
                        //   child: EText('Mot de passe oublié ?',
                        //       color: AppColors.textColor,
                        //       weight: FontWeight.w600,
                        //       size: 20),
                        // ),
                      // Wrap(
                      //     alignment: WrapAlignment.center,
                      //     crossAxisAlignment: WrapCrossAlignment.center,
                      //     children: [
                      //       EText("Vous n'avez pas encore de compte ?"),
                      //       TextButton(
                      //           onPressed: () {
                      //             Get.to(Inscription(
                      //               function: () {},
                      //             ));
                      //           },
                      //           child: EText("S'inscrire", color: AppColors.color500,))
                      //     ],
                      //   ),
                      ])),
            ),
          ),
        ),
      ),
    );
  }

  void forgotPassword(context) async {
    if (GFunctions.isPhoneNumber(country: country, numero: telephone)) {
      try {
        var q =
            await DB.firestore(Collections.utilistateurs).doc(telephone).get();
        if (q.exists) {
          isLoading.value = true;
          await Utilisateur.getUser(telephone);

          var utilisateur = Utilisateur.fromMap(q.data()!);

          var auth = FirebaseAuth.instance;

          await auth.verifyPhoneNumber(
            phoneNumber: '+228${utilisateur.telephone}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              isLoading.value = false;

              Custom.showDialog(const WarningWidget(
                message:
                    'Erreur lors de la verification du numero, veuillez réessayer plus tard',
              ));
            },
            codeSent: (String verificationId, int? resendToken) async {
              isLoading.value = false;

              // Get.to(Verification(
              //     verificationId: verificationId, utilisateur: utilisateur));
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        } else {
          isLoading.value = false;

          Custom.showDialog(const WarningWidget(
            message:
                'Pas de compte associé à ce numero. veuillez creer un compte',
          ));
        }
      } on Exception {
        isLoading.value = false;

        Custom.showDialog(const WarningWidget(
          message:
              "Une erreur s'est produite. veuillez verifier votre connexion internet",
        ));
      }
    } else {
      Toasts.error(
        context,
        description: "Entrez un numero valide",
      );
    }
  }
}

class ChooseCountryCode extends StatelessWidget {
  const ChooseCountryCode({
    super.key,
    required this.onChanged,
  });
  final onChanged;
  @override
  Widget build(BuildContext context) {
    var phoneScallerFactor = MediaQuery.of(context).textScaleFactor;

    return CountryCodePicker(
      flagWidth: 25,
      onChanged: onChanged,
      initialSelection: 'TG',
      favorite: const ['+228', 'TG'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      textStyle: TextStyle(
        fontSize: 20 * .7 / phoneScallerFactor,
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(right: 6),
    );
  }
}
