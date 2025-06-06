// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immobilier_apk/firebase_options.dart';
import 'package:immobilier_apk/scr/config/app/export.dart';
import 'package:immobilier_apk/scr/config/theme/app_theme.dart';
import 'package:immobilier_apk/scr/ui/pages/messages/details.dart';
import 'package:immobilier_apk/scr/ui/pages/precache/precache.dart';
import 'package:immobilier_apk/scr/ui/pages/update/update_page.dart';
import 'package:my_widgets/real_state/models/message.dart' as message;

String version = "1.0.0+3";

Update update = Update(version: "1.0.0+3", optionel: false);

double phoneScallerFactor = 1;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  var user = FirebaseAuth.instance.currentUser;
  if (user.isNotNul) {
    if (user!.email != null) {
      await Utilisateur.getUser(user.email!);
    } else {
      await Utilisateur.getUser(user.phoneNumber!.substring(4));
    }
    // verifyPaiements();
  }

  runApp(GetMaterialApp(
   
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: LoadingPage(),
    defaultTransition: Transition.leftToRight,
    transitionDuration: 999.milliseconds,
  ));

}

void goToDetailPage({required Map<String, dynamic> notificationData}) async {
  var update = await getUpdateVersion();
  if (update.version != version) {
    Get.off(
      const UpdatePage(),
      transition: Transition.rightToLeftWithFade,
      duration: 333.milliseconds,
    );
  } else {
    
      var msg = message.Message.fromMap(notificationData);

      Get.dialog(MessageDetails(message: msg, entrepriseID: null,));

  
    
  }
}



Future<String?> getPaygateApiKey() async {
  DocumentSnapshot<Map<String, dynamic>> q;
  try {
    q = await DB.firestore(Collections.keys).doc('apiKey').get();
    return q != null ? q.data()!['apiKey'] : null;
  } on Exception {
    // TODO
  }
  return null;
}

Future<Update> getUpdateVersion() async {
  var q = await DB.firestore(Collections.keys).doc('update').get();
  return Update.fromMap(q.data() ?? update.toMap());
}
