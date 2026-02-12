/**
 * Created by Jaimin on 30/05/24.
 */

part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;

  //---------------|| Auth ||-----------------------//
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const VERIFYOTP = _Paths.VERIFYOTP;
  static const APPLYREFERRALVIEW = _Paths.APPLYREFERRALVIEW;


  //---------------|| Dashboard ||-----------------------//
  static const DASHBOARD = _Paths.DASHBOARD;
  static const HOMEVIEW = _Paths.HOMEVIEW;
  static const REPORTSVIEW = _Paths.REPORTSVIEW;


  static const SURVEYVIEW = _Paths.SURVEYVIEW;
  static const YOLOCAMERAVIEW = _Paths.YOLOCAMERAVIEW;
  static const DAMAGEREPAIRTAB = _Paths.DAMAGEREPAIRTAB;
  static const VIDEOVIEW = _Paths.VIDEOVIEW;
  static const EDITPROPERTYINFOVIEW = _Paths.EDITPROPERTYINFOVIEW;
  static const DAMAGEDETAIL = _Paths.DAMAGEDETAIL;
  static const SUGGESTEDREPAIR = _Paths.SUGGESTEDREPAIR;
  static const EDITDAMAGE = _Paths.EDITDAMAGE;
  static const EDITREPAIRMATERIAL = _Paths.EDITREPAIRMATERIAL;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const THREEDWALKTHROUGHVIEW = _Paths.THREEDWALKTHROUGHVIEW;
  static const THREEDSURVEYVIEW = _Paths.THREEDSURVEYVIEW;
  static const COMPLETEDTHREEDMODELVIEW = _Paths.COMPLETEDTHREEDMODELVIEW;
  static const THREEDMODELLISTVIEW = _Paths.THREEDMODELLISTVIEW;
  static const THREEDVIDEOVIEW = _Paths.THREEDVIDEOVIEW;
  static const SETTINGS = _Paths.SETTINGS;
  static const EDITPROFILE = _Paths.EDITPROFILE;
  static const SUBSCRIPTION = _Paths.SUBSCRIPTION;
  static const PAYMENTSUCCESS = _Paths.PAYMENTSUCCESS;
  static const COMMONCMSVIEW = _Paths.COMMONCMSVIEW;
  static const FAQVIEW = _Paths.FAQVIEW;

}

abstract class _Paths {
  static const SPLASH = '/splashView';

  //---------------|| Auth ||-----------------------//
  static const ONBOARDING = '/onboardingView';
  static const LOGIN = '/loginView';
  static const VERIFYOTP = '/verifyOtpView';
  static const APPLYREFERRALVIEW = '/apply-referral-view';

  //---------------|| Dashboard ||-----------------------//
  static const DASHBOARD = '/dashboardView';
  static const HOMEVIEW = '/homeView';
  static const REPORTSVIEW = '/reportsView';


  static const SURVEYVIEW = '/surveyView';
  static const YOLOCAMERAVIEW = '/yolocameraView';
  static const DAMAGEREPAIRTAB = '/damagerepairTab';
  static const VIDEOVIEW = '/videoView';
  static const EDITPROPERTYINFOVIEW = '/editpropertyinfoView';
  static const DAMAGEDETAIL = '/damageDetailView';
  static const SUGGESTEDREPAIR = '/suggestedRepairView';
  static const EDITDAMAGE = '/editDamageView';
  static const EDITREPAIRMATERIAL = '/editrepairMaterialView';
  static const NOTIFICATION = '/notificationView';
  static const THREEDWALKTHROUGHVIEW = '/threeDWalkthroughView';
  static const THREEDSURVEYVIEW = '/threeDSurveyView';
  static const COMPLETEDTHREEDMODELVIEW = '/completedThreeDModelView';
  static const THREEDMODELLISTVIEW = '/threeDModelListView';
  static const THREEDVIDEOVIEW = '/threeDVideoView';
  static const SETTINGS = '/settingsView';
  static const EDITPROFILE = '/editProfileView';
  static const SUBSCRIPTION = '/subscriptionView';
  static const PAYMENTSUCCESS = '/paymentSuccessView';
  static const COMMONCMSVIEW = '/commonCmsView';
  static const FAQVIEW = '/faqView';

}
