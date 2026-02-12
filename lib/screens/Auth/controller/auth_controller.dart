import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../utils/config.dart';
import '../../../utils/full_screen_loader.dart';
import '../../../widgets/custom_log.dart';
import '../repo/auth_repo.dart';

class AuthController extends GetxController{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static bool isInitialize = false;
  var isLogin = true.obs;
  final box = GetSecureStorage();
  var  FCM_Token = ''.obs;
  var isLoading = false.obs;
  var overlay = LoadingOverlay();



  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      // Trigger the Google Sign-In flow.
      final googleUser = await _googleSignIn.signIn();

      // User canceled the sign-in.
      if (googleUser == null) return null;

      // Retrieve the authentication details from the Google account.
      final googleAuth = await googleUser.authentication;

      // Create a new credential using the Google authentication details.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential.
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Console.Log(title: 'User>>>>>>>.', message:googleAuth.idToken);
        print('User>>>>>>>.${googleAuth.idToken}');
        Console.Log(title: 'AccessTenUser>>>>>>>.', message:googleAuth.accessToken);
        FCM_Token.value = await FirebaseMessaging.instance.getToken() ?? 'Token';
        //FCM_Token.value = 'Token';
        Console.Log(title: 'FCM Token', message: FCM_Token.value);
        print( 'FCM Token:${FCM_Token.value}');
        box.write(fcmToken, FCM_Token.value);
        isLoading.value = true;
        update();
        overlay.show();
        isLoading.value = await AuthRepo.socialLogin(
          socialType: "google",
          signINToken: googleAuth.idToken,
          isLogin: isLogin.value,
        );
        update();
        /*final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoURL': user.photoURL ?? '',
            'provider': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }*/
      }
      // Return the authenticated user.
      return userCredential.user;
    } catch (e) {

      // Print the error and return null if an exception occurs.
      print("Sign-in error: $e");
      return null;
    }
  }

  Future<dynamic?> signInWithApple() async {
    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        print('Sign in with Apple is not available on this device');
        return;
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
//>G0\AL55c[3s>B@
      Console.Log(message: credential.email ?? '', title: 'AppleLoginEmail');
      Console.Log(message: credential.givenName ?? '', title: 'AppleName');
      Console.Log(
        message: credential.authorizationCode ?? '',
        title: 'AppleName',
      );
      Console.Log(
        message: credential.identityToken ?? '',
        title: 'AppleIdToken',
      );
      print('${credential.identityToken}>>>>>>>>AppleIdToken');
      print('${credential.authorizationCode}>>>>>>>>AppleName');
      Console.Log(title: 'User>>>>>>>.', message:credential.identityToken);
      FCM_Token.value = await FirebaseMessaging.instance.getToken() ?? 'Token';
      //FCM_Token.value = 'Token';
      Console.Log(title: 'FCM Token', message: FCM_Token.value);
      box.write(fcmToken, FCM_Token.value);
      isLoading.value = true;
      update();
      overlay.show();
      isLoading.value = await AuthRepo.socialLogin(
        socialType: "apple",
        signINToken: credential.identityToken,
        isLogin: isLogin.value,
      );
      update();
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}