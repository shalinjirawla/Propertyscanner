/**
 * Created by Darshit on 18/12/25.
 */



import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_log.dart';

class ApiServices {
  static final box = GetSecureStorage();

  static Future ApiProvider(
    int isPost, {
    String? url,
    Map<String, dynamic>? body,
    var authToken,
  }) async {
    Console.Log(title: "Api Auth Token>>>>>", message: authToken);
    var headers = {
      "Content-Type": "application/json",
      if (authToken != null) 'Authorization':'$authToken',
      //'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };
    http.Response? response;
    dev.log('Header : $headers');

    try {
      if (isPost == 0) {
        response = await http.get(Uri.parse(url!), headers: headers);
      } else if (isPost == 1) {
        response = await http.post(Uri.parse(url!),
            body: json.encode(body), headers: headers);
      } else if (isPost == 2) {
        response = await http.put(Uri.parse(url!),
            body: json.encode(body), headers: headers);
      }
      //Console.Log(message: response!.body, title: 'Api Body');
      dev.log('Api : ${response!.request}');
      switch (response.statusCode) {
        case 200:
          return response.body;
        case 400:
          dev.log('Bed Request Error');
          throw Exception(
              "The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, size too large, invalid request message framing, or deceptive request routing).  ==> ${response.statusCode}");
        case 401:
          dev.log(
              'The user does not have valid authentication credentials for the target resource');
          throw Exception(
              "The user does not have valid authentication credentials for the target resource ==> ${response.statusCode}");
        case 404:
          dev.log('Page Not Found');
          throw Exception("Page Not Found ==> ${response.statusCode}");
        case 500:
          dev.log('Internal Server Error');
          //showSnackBar(isError: true, message: 'Internal Server Error');
          throw Exception("Internal Server Error ==> ${response.statusCode}");
        case 502:
          dev.log('Bad Gateway');
          //showSnackBar(isError: true, message: 'Bad Gateway');
          throw Exception("Internal Server Error ==> ${response.statusCode}");

        case 102:
          dev.log('Internal Server Error');
          //showSnackBar(isError: true, message: 'Internal Server Error');
          throw Exception("Internal Server Error ==> ${response.statusCode}");
      }
    } on SocketException catch (e) {
      Console.Log(title: 'SocketExceptionError', message: e.toString());
    } catch (error) {
      dev.log("Error From the Web services  ===> $error");
      //var profileController = Get.find<ProfileController>();
      if (error.toString().contains('401')) {
        /*CustomDialog.showAlreadyLoginDialog(
          message:
              'You are already logged in in another device, please log in again',
          title: 'Ohh!',
          onTap: () {
            var currentUID = box.read(MixPanelHelper.kAppsFlyerUidKey);
            box.erase();
            profileController.signOut();
            Get.offAll(() => const LoginView());
            box.write('isFirstLaunch', false);
            box.write(MixPanelHelper.kInstallTrackedKey, true);
            box.write(MixPanelHelper.kAppsFlyerUidKey, currentUID);
          },
        );*/
      }

      return Exception("Something went wrong. Please try again later.");
    }
  }
}
