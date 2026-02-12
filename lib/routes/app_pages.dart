/**
 * Created by Darshit on 18/12/25.
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/binding/3d_walkthrough_binding.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_model_list_view.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_survey_view.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_video_view.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/3d_walthrough_view.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/view/completed_3d_model_view.dart';
import 'package:property_scan_pro/screens/DamageDetail/binding/damage_detail_binding.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/binding/damage_repair_tab_binding.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/view/damage_repair_tab_view.dart';
import 'package:property_scan_pro/screens/DamageRepairTab/widget/video_view.dart';
import 'package:property_scan_pro/screens/DashBoard/binding/dash_binding.dart';
import 'package:property_scan_pro/screens/DashBoard/view/home_view.dart';
import 'package:property_scan_pro/screens/DashBoard/view/report_view.dart';
import 'package:property_scan_pro/screens/EditPropertyInfo/binding/edit_property_info_binding.dart';
import 'package:property_scan_pro/screens/EditPropertyInfo/view/edit_property_info_view.dart';
import 'package:property_scan_pro/screens/EditRepairMaterial/view/edit_repair_material_view.dart';
import 'package:property_scan_pro/screens/Notification/binding/notification_binding.dart';
import 'package:property_scan_pro/screens/Notification/view/notification_view.dart';
import 'package:property_scan_pro/screens/OnBoarding/binding/onboarding_binding.dart';
import 'package:property_scan_pro/screens/OnBoarding/view/onboarding_view.dart';
import 'package:property_scan_pro/screens/Settings/binding/settings_binding.dart';
import 'package:property_scan_pro/screens/Settings/view/comoon_cms_view.dart';
import 'package:property_scan_pro/screens/Settings/view/edit_profile_view.dart';
import 'package:property_scan_pro/screens/Settings/view/faq_view.dart';
import 'package:property_scan_pro/screens/Settings/view/payment_syccess_view.dart';
import 'package:property_scan_pro/screens/Settings/view/subscription_view.dart';
import 'package:property_scan_pro/screens/Splash/view/splash_view.dart';
import 'package:property_scan_pro/screens/SuggestedRepair/binding/suggested_repair_binding.dart';
import 'package:property_scan_pro/screens/SuggestedRepair/view/edit_damage_view.dart';
import 'package:property_scan_pro/screens/SuggestedRepair/view/suggested_repair_view.dart';
import 'package:property_scan_pro/screens/Survey/binding/survey_binding.dart';
import 'package:property_scan_pro/screens/Survey/view/survey_view.dart';
import 'package:property_scan_pro/screens/YoloCamera/binding/yolocamera_binding.dart';
import 'package:property_scan_pro/screens/YoloCamera/view/yolo_camera_view.dart';

import '../screens/Auth/binding/auth_binding.dart';
import '../screens/Auth/view/login_view.dart';
import '../screens/DamageDetail/view/damage_detail_view.dart';
import '../screens/DashBoard/view/dashboard_view.dart';
import '../screens/DashBoard/view/settings_view.dart';
import '../screens/EditRepairMaterial/binding/edit_repair_material_binding.dart';
import '../screens/Splash/binding/splash_binding.dart';


part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    // //---------------|| Auth ||-----------------------//
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),

    //---------------|| DASHBOARD ||-----------------------//
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashBoardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.HOMEVIEW,
      page: () => HomeView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.REPORTSVIEW,
      page: () => ReportsView(),
      binding: DashboardBinding(),
    ),



    GetPage(
      name: _Paths.SURVEYVIEW,
      page: () => SurveyView(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: _Paths.YOLOCAMERAVIEW,
      page: () => YoloCameraView(),
      binding: YoloCameraBinding(),
    ),
    GetPage(
      name: _Paths.DAMAGEREPAIRTAB,
      page: () => DamageRepairTabView(),
      binding: DamageRepairTabBinding(),
    ),
    GetPage(
      name: _Paths.VIDEOVIEW,
      page: () => VideoView(),
      binding: DamageRepairTabBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROPERTYINFOVIEW,
      page: () => EditPropertyInfoView(),
      binding: EditPropertyInfoBinding(),
    ),
    GetPage(
      name: _Paths.DAMAGEDETAIL,
      page: () => DamageDetailView(),
      binding: DamageDetailBinding(),
    ),
    GetPage(
      name: _Paths.SUGGESTEDREPAIR,
      page: () => SuggestedRepairView(),
      binding: SuggestedRepairBinding(),
    ),
    GetPage(
      name: _Paths.EDITDAMAGE,
      page: () => EditDamageView(),
      binding: SuggestedRepairBinding(),
    ),
    GetPage(
      name: _Paths.EDITREPAIRMATERIAL,
      page: () => EditRepairMaterialView(),
      binding: EditRepairMaterialBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.THREEDWALKTHROUGHVIEW,
      page: () => ThreeDWalkthroughView(),
      binding: ThreeDWalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.THREEDSURVEYVIEW,
      page: () => ThreeDSurveyView(),
      binding: ThreeDWalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETEDTHREEDMODELVIEW,
      page: () => Completed3dModelView(),
      binding: ThreeDWalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.THREEDMODELLISTVIEW,
      page: () => ThreeDModelListView(),
      binding: ThreeDWalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.THREEDVIDEOVIEW,
      page: () => ThreeDVideoView(),
      binding: ThreeDWalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => EditProfileView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION,
      page: () => SubscriptionView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENTSUCCESS,
      page: () => PaymentSuccessView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.COMMONCMSVIEW,
      page: () => CommonCmsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.FAQVIEW,
      page: () => FaqPage(),
      binding: SettingsBinding(),
    ),

  ];

}
