import 'package:chamadainteligente/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseManager {
  static Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBnXFuo3EJwapAgDaw5ZFt1q0mUsJieq7A",
          authDomain: "chamada-inteligente.firebaseapp.com",
          databaseURL:
              "https://chamada-inteligente-default-rtdb.firebaseio.com",
          projectId: "chamada-inteligente",
          storageBucket: "chamada-inteligente.appspot.com",
          messagingSenderId: "368112514569",
          appId: "1:368112514569:web:388d808bfc7f73bbf1ead8",
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}
