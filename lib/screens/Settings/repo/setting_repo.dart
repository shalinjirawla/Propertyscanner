import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:property_scan_pro/screens/Settings/controller/settings_controller.dart';
import 'package:property_scan_pro/screens/Settings/model/get_profile_model.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../components/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../model/cms_model.dart';
import '../model/faq_model.dart';

class SettingRepo {
  static final box = GetSecureStorage();
  static var
      cmsPageData = cmsData();
  static var
  faqListData = <FaqsData>[];
  static var profileGetData = ProfileData();


  static Future<bool> getCMSPages({String? pagesName}) async {
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${cmsPage}/$pagesName',
        authToken: null,
      );
      Console.Log(title: 'getCMSPage', message: res);
      var data = cmsModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
         cmsPageData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getEarnCoinListError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getEarnCoinListError', message: e);
      return false;
    }
  }

  static Future<bool> getFaqPage() async {
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${faqPage}',
        authToken: null,
      );
      Console.Log(title: 'getCMSPage', message: res);
      var data = faqModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
        faqListData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getEarnCoinListError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getEarnCoinListError', message: e);
      return false;
    }
  }


  static Future<bool> logOutApi() async {
    var authToken = box.read(token);
    print('🔍 Logout Request Details:');
    print('URL:${Config.BaseUrl}${logOutApiData}');
    print('Token: Bearer $authToken');
    print('Method: POST (1)');
    try {
      var res = await ApiServices.ApiProvider(
        1,
        url: '${Config.BaseUrl}${logOutApiData}',
        authToken: "Bearer ${authToken}",
        body: null
      );
      var data = json.decode(res);
      if (data["status"] == true) {
        Console.Log(title: 'logoutUserResponse', message: data);
        showSnackBar(message: data['message'], isError: false);
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
       box.erase();
       box.remove(token);
       box.write(onBoarding, true);
       Get.offAllNamed(Routes.LOGIN);
        return false;
      } else {
        showSnackBar(message: data['message'], isError: true);
        Console.Log(title: 'logoutError', message: data);
        return false;
      }
    } catch (e) {
      showSnackBar(message: e, isError: true);
      Console.Log(title: 'logoutErrorCatch', message: e);
      return false;
    }
  }


  static Future<bool> getProfileData() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${profileGet}',
        authToken: "Bearer ${authToken}",
      );
      Console.Log(title: 'getProfileData', message: res);
      var data = getProfileModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
        profileGetData = data.data!;
        return false;
      } else {
        Console.Log(title: 'getEarnCoinListError', message: data);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'getEarnCoinListError', message: e);
      return false;
    }
  }


  static Future<bool> updateUserProfile({var bodyData}) async {
    var authToken = box.read(token),settingController = Get.put(SettingsController());
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${Config.BaseUrl}$profileUpdate'),
      );
      Console.Log(title: 'updateUserProfileResponse', message: request);
      request.fields["name"] = bodyData['name'];
      request.fields["gender"] = bodyData['gender'];
      request.headers.addAll({
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
        'Access-Control-Allow-Origin': '*',
      });

      if (bodyData['profile_pic'] != null &&
          bodyData['profile_pic'].toString().isNotEmpty) {
        var pic = await http.MultipartFile.fromPath(
            "profile_pic", bodyData['profile_pic']);

        request.files.add(pic);
        Console.Log(
            title: 'EditProfileBodyImage', message: bodyData['profile_pic']);
      }
      Console.Log(title: 'EditProfileBody', message: request.fields);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = json.decode(responseString);
      Console.Log(title: 'ProfileSuccess', message: responseString);
      if (data['status'] == true) {
        await getProfileData();
        box.write(isProfileComplete, false);
        if (profileGetData != null) {
          settingController.profileDataGetList.value = profileGetData;
          settingController.update(['profile']);
          settingController.isImageAvailable.value = false;
          box.write(userPicture,profileGetData.profilePic??'');
          settingController.profileImage.value = profileGetData.profilePic??'';
          Console.Log(title:settingController.profileImage.value,message: "j>>>>>>" );
        }
        Get.back();
        showSnackBar(message: data['message'], isError: false);
        return false;
      } else {
        showSnackBar(message: data['message'], isError: true);
        return false;
      }
    } catch (e) {
      Console.Log(title: 'updateUserProfileError', message: e);
      showSnackBar(message: e.toString(), isError: true);
      return false;
    }
  }

}