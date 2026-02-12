import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_scan_pro/screens/Settings/model/get_profile_model.dart';

import '../../../components/custom_snackbar.dart';
import '../model/cms_model.dart';
import '../model/faq_model.dart';
import '../repo/setting_repo.dart';

class SettingsController extends GetxController{
  var isLoading = false.obs;
  var isLoadingLogOut = false.obs;
  var isLoadingProfile = false.obs;
  var isLoadingProfileUpdate = false.obs;
  var isFaqLoading = false.obs;
  var cmsPageData = cmsData().obs;
  var profileDataGetList = ProfileData().obs;
  var faqPageDataList = <FaqsData>[].obs;

  var fullNameController = TextEditingController().obs;
   var emailController = TextEditingController().obs;


  var selectedGender = 'female'.obs,profileImage = ''.obs;
  var selectedFile;
  XFile? pickedFile;
  var isImageAvailable = false.obs;


  Future<void> getCmsListPage(String cmsPageName) async {
    cmsPageData.value = cmsData();
    isLoading.value = true;
    isLoading.value = await SettingRepo.getCMSPages(pagesName: cmsPageName);
    if (SettingRepo.cmsPageData != null) {
      cmsPageData.value = SettingRepo.cmsPageData;
    }
  }

  Future<void> getFaqListPage() async {
    isFaqLoading.value = true;
    isFaqLoading.value = await SettingRepo.getFaqPage();
    if (SettingRepo.faqListData != null) {
      faqPageDataList.value = SettingRepo.faqListData;
    }
  }

  Future<void> logoutUser() async {
    isLoadingLogOut.value = true;
    isLoadingLogOut.value = await SettingRepo.logOutApi();
  }

  Future<void> getDataProfile() async {
    isLoadingProfile.value = true;
    isLoadingProfile.value = await SettingRepo.getProfileData();
    if (SettingRepo.profileGetData != null) {
      profileDataGetList.value = SettingRepo.profileGetData;
      fullNameController.value = TextEditingController(text: profileDataGetList.value.name??'');
      emailController.value = TextEditingController(text: profileDataGetList.value.email ??'');
      selectedGender.value = profileDataGetList.value.gender ?? "female";
      profileImage.value = profileDataGetList.value.profilePic ??'';
      if(profileImage.value.isNotEmpty){
        isImageAvailable.value = true;
      }
    }
  }

  void validateEditProfile() {
    if (isImageAvailable.value == false &&
        selectedFile == null) {
      showWarningSnackBar(message: 'Please select avatar');
    } else if (fullNameController.value.text.isEmpty) {
      showWarningSnackBar(message: 'Please enter username');
    } else if (selectedGender.value.isEmpty) {
      showWarningSnackBar(message: 'Please select gender');
    } else {
      updateProfile();
    }
  }

  void updateProfile() async {
    isLoadingProfileUpdate.value = true;
    isLoadingProfileUpdate.value = await SettingRepo.updateUserProfile(
        bodyData: {
          'name': fullNameController.value.text.trim(),
          'gender': selectedGender.value,
          if (isImageAvailable.value == false)
            'profile_pic': isImageAvailable.value == false
                ? selectedFile
                : '',
        });
  }

}