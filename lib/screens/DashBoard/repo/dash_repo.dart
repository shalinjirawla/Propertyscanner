import 'package:get_secure_storage/get_secure_storage.dart';

import '../../../ApiManager/ApiService.dart';
import '../../../Environment/core/core_config.dart';
import '../../../utils/config.dart';
import '../../../widgets/custom_log.dart';
import '../model/report_model.dart';

class DashRepo{



  static final box = GetSecureStorage();
  static var reportListData = <ReportData>[];
  static var notificationListData = <ReportData>[];

  static Future<bool> getReportListPage() async {
    var authToken = box.read(token);
    try {
      var res = await ApiServices.ApiProvider(
        0,
        url: '${Config.BaseUrl}${surveyReportList}',
        authToken:"Bearer ${authToken}",
      );
      Console.Log(title: 'getReportPage', message: res);
      var data = getReportModelFromJson(res);
      if (data.status == true) {
        //Console.Log(title: 'getUserProfileResponse', message: data.data!);
        reportListData = data.data!;
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


}