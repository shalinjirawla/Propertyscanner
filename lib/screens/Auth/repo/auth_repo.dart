import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../controller/auth_controller.dart';

class AuthRepo {
  static final box = GetSecureStorage();


  static Future<bool> socialLogin({
    var signINToken,
    var isLogin,
    var socialType,
  }) async {
    var authController = Get.put(AuthController());
    var deviceToken = box.read(fcmToken) ?? 'Token';
    var body = {
      "fcm_token": deviceToken, //androidInfo!.version.baseOS??
    };

    Console.Log(title: 'SocialLoginBody', message: json.encode(body));
    try {
      var res = await ApiServices.ApiProvider(
        1,
        url: socialType =="google"?'${Config.BaseUrl}$socialSignIn':'${Config.BaseUrl}$socialSignInApple',
        authToken: "Bearer ${signINToken}",// isLogin
        body: body,
      );
      Console.Log(title: 'LoginRes', message: res);
      var data = json.decode(res);
      if (data['status'] == true) {
        Get.back();
        Console.Log(title: 'SocialLoginResponse', message: data);
        Console.Log(title: 'Token>>>>>>>>>>>>>>', message: data["data"]['token']);
        box.write(token, data["data"]['token']);
        box.write(userName, data["data"]['user']['name'] ??'');
        box.write(userId, data["data"]['user']['id']);
        box.write(userPicture, data["data"]['user']['profile_pic']??'');
        Console.Log(title: 'userPicture>>>>>>>>>>>>>>', message: userPicture);
        if(socialType =="google"){
          box.write("google", true);
        } else if(socialType == "apple"){
          box.write("apple", true);
        }
        box.write(isProfileComplete, true);

        showSnackBar(isError: false, message: data['message']);
          Get.offAllNamed(Routes.DASHBOARD);

        return false;
      } else {
        Get.back();
        if (data['message'].toString().contains('No user found')) {
          authController.isLogin.value = false;
        }
        showSnackBar(isError: true, message: data['message']);
        Console.Log(title: 'LoginError', message: data['message']);
        return false;
      }
    } catch (e) {
      Get.back();
      Console.Log(title: 'LoginErrorCatch', message: e);
      return false;
    }
  }


}