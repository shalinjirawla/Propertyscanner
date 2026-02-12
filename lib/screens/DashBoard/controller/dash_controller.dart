import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:property_scan_pro/screens/DashBoard/repo/dash_repo.dart';
import 'package:property_scan_pro/screens/DashBoard/view/dashboard_view.dart';
import 'package:property_scan_pro/utils/full_screen_loader.dart';

import '../../../Database/database_helper.dart';
import '../../../components/custom_snackbar.dart';
import '../../../routes/app_pages.dart';
import '../../3DWalkthrough/view/3d_walthrough_view.dart';
import '../../DamageRepairTab/repo/damage_repair_repo.dart';
import '../../DamageRepairTab/repo/azure_storage_service.dart';
import '../../Notification/controller/notification_controller.dart';
import 'dart:io';
import '../model/report_model.dart';
import '../view/home_view.dart';
import '../view/report_view.dart';
import '../view/settings_view.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt currentIndex = 0.obs;
  var isLoadingReport = false.obs;
  var reportPageDataList = <ReportData>[].obs;
  var notificationController = Get.put(NotificationController());
  var box = GetSecureStorage();
  var profileImage = ''.obs;
  var overlay = LoadingOverlay();

  // // Navigation datas
  // final List<Map<String, dynamic>> _navItems = [
  //   {'label': 'Home', 'icon': Icons.home_filled, 'showOnAllPlatforms': true},
  //   {'label': 'Reports', 'icon': Icons.assessment, 'showOnAllPlatforms': true},
  //   {'label': '3D Walkthrough', 'icon': Icons.threesixty, 'showOnAllPlatforms': true},
  //   {'label': 'Settings', 'icon': Icons.settings, 'showOnAllPlatforms': true},
  // ];
  //
  // // Get filtered navigation items based on platform
  // List<Map<String, dynamic>> get filteredNavItems {
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     // Filter out items not marked for all platforms
  //     return _navItems.where((item) => item['showOnAllPlatforms'] == true).toList();
  //   }
  //   return _navItems;
  // }
  //
  // // Get labels for current platform
  // List<String> get labels => filteredNavItems.map((item) => item['label'] as String).toList();
  //
  // // Get icons for current platform
  // List<IconData> get icons => filteredNavItems.map((item) => item['icon'] as IconData).toList();
  //
  // // Get pages for current platform
  // List<Widget> getPages(BuildContext context) {
  //   // Define all pages
  //   final allPages = [
  //      HomeView(),
  //     ReportsView(),
  //     ThreeDWalkthroughView(),
  //     SettingsView(),
  //   ];
  //
  //   // Filter based on platform
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     return [
  //       HomeView(),
  //       ReportsView(),
  //       ThreeDWalkthroughView(),
  //       SettingsView(),
  //     ];
  //   }
  //   return allPages;
  // }
  //
  // // Change tab with platform-aware index adjustment
  // void changeTab(int index) {
  //   currentIndex.value = index;
  // }
  // void changeIndex(
  //     int index, {
  //       String? pageName,
  //     }) {
  //   currentIndex.value = index;
  //   Get.offAndToNamed(pageName!, );
  //
  // }
  //
  // // Get current page name
  // String get currentPage => labels[currentIndex.value];

  final RxBool isLoading = false.obs;

  // Report View State
  var offlineReports = <ReportModel>[].obs;

  // Search State
  var isSearchActive = false.obs;
  final TextEditingController searchController = TextEditingController();
  var searchList = <ReportData>[].obs;

  // Sync State
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isAutoSyncing = false;
  bool _shouldStopSync = false;

  // Sync Progress State
  var isSyncing = false.obs;
  var syncStatusMessage = ''.obs;
  var syncProgress = 0.0.obs;

  final PageController pageController = PageController();
  @override
  void onInit() {
    super.onInit();
    // Initialize search list with all data
    ever(reportPageDataList, (_) {
      if (!isSearchActive.value && searchController.text.isEmpty) {
        searchList.assignAll(reportPageDataList);
      } else if (searchController.text.isNotEmpty) {
        filterReports(searchController.text);
      }
    });
    notificationController.getNotificationPageList();

    // Initial fetch and setup listener
    //getOfflineReports();
    //setupConnectivityListener();
  }

  @override
  void onClose() {
    pageController.dispose();
    // searchController.dispose(); // Kept alive as DashboardController might be long-lived or reused
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void onNavBarTap(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
    if (index == 1) {
      getReportPageList();
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    print('JJJJJJ${currentIndex.value}');
  }

  void startNewSurvey() {
    Get.toNamed(Routes.SURVEYVIEW);
  }

  void signOut() async {
    //await _supabaseService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> getReportPageList({bool showLoading = true}) async {
    if (showLoading) isLoadingReport.value = true;
    var result = await DashRepo.getReportListPage();
    if (showLoading) {
      isLoadingReport.value = result;
    }
    if (DashRepo.reportListData != null) {
      reportPageDataList.value = DashRepo.reportListData;
    }
  }

  // Search Logic
  // Legacy getters/setters if any were used, can be removed or adapted.
  // ...

  // Offline Reports & Auto-Sync Logic
  Future<void> getOfflineReports() async {
    // Don't interfere if sync is already in progress
    if (isSyncing.value) return;

    final reports = await DatabaseHelper.instance.getAllReports();
    offlineReports.assignAll(reports);

    // Check if we need to auto-sync
    if (offlineReports.isNotEmpty && !_isAutoSyncing) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        //auto sync is temparory disable
        startAutoSync();
      }
    }
  }

  void setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      // Double check connectivity status
      bool isOnline = !results.contains(ConnectivityResult.none);

      if (isOnline) {
        _shouldStopSync = false;
        // Refresh offline reports before starting sync to ensure we have any new ones
        //await getOfflineReports();
        if (offlineReports.isNotEmpty && !_isAutoSyncing) {
          startAutoSync();
        }
      } else {
        _shouldStopSync = true;
      }
    });
  }

  Future<void> startAutoSync() async {
    if (_isAutoSyncing || offlineReports.isEmpty) return;

    _isAutoSyncing = true;
    isSyncing.value = true;
    syncProgress.value = 0.0;

    int totalReports = offlineReports.length;
    int processedCount = 0;

    try {
      while (offlineReports.isNotEmpty && !_shouldStopSync) {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none)) {
          _shouldStopSync = true;
          break;
        }

        ReportModel currentReport = offlineReports.first;

        // Update progress UI
        processedCount++;
        syncStatusMessage.value =
            'Syncing $processedCount of $totalReports: ${currentReport.title ?? "Report"}';
        syncProgress.value = processedCount / totalReports;

        Get.closeAllSnackbars();
        // showSnackBar(
        //   message: 'Syncing ${currentReport.title ?? "Report"}...',
        //   isError: false,
        // ); // Optional: remove snackbar to avoid clutter if using progress bar

        try {
          List<Map<String, dynamic>> damagesForApi = [];
          if (currentReport.damages != null) {
            List<dynamic> storedDamages = jsonDecode(currentReport.damages!);
            for (var item in storedDamages) {
              Uint8List? imageBytes;
              if (item['image'] != null) {
                imageBytes = base64Decode(item['image']);
              }
              damagesForApi.add({
                'damage_name': item['damage_name'],
                'image': imageBytes,
              });
            }
          }

          String? videoUrl;
          if (currentReport.scanVideoPath != null &&
              currentReport.scanVideoPath!.isNotEmpty) {
            try {
              File videoFile = File(currentReport.scanVideoPath!);
              if (videoFile.existsSync()) {
                syncStatusMessage.value =
                    'Uploading video for ${currentReport.title}...';
                videoUrl = await AzureStorageService.uploadVideo(videoFile);
                if (videoUrl == null) {
                  throw Exception("Failed to upload video to Azure");
                }
              }
            } catch (e) {
              showSnackBar(
                message: 'Error uploading video for ${currentReport.title}: $e',
                isError: true,
              );
              _shouldStopSync = true;
              continue; // Skip this report or stop? User said "API should NOT be called"
            }
          }

          Map<String, dynamic> bodyData = {
            'property_name': currentReport.title,
            'property_address': currentReport.address,
            'summary': currentReport.summary,
            'damages': damagesForApi,
            'video_url': videoUrl,
            /*'capture_video': videoUrl == null
                ? currentReport.scanVideoPath
                : null,*/
          };

          var result = await DamageRepo.uploadOfflineReport(bodyData: bodyData);

          if (result['success'] == true) {
            if (currentReport.id != null) {
              await DatabaseHelper.instance.deleteReport(currentReport.id!);
            }

            offlineReports.removeAt(0);

            showSnackBar(
              message: 'Synced: ${currentReport.title}',
              isError: false,
            );

            getReportPageList(showLoading: false);
          } else {
            showSnackBar(
              message:
                  'Failed to sync ${currentReport.title}: ${result['message']}',
              isError: true,
            );
            _shouldStopSync = true;
          }
        } catch (e) {
          showSnackBar(
            message: 'Error syncing ${currentReport.title}: $e',
            isError: true,
          );
          _shouldStopSync = true;
        }
      }
    } finally {
      _isAutoSyncing = false;
      isSyncing.value = false;
      syncStatusMessage.value = '';
      syncProgress.value = 0.0;
    }
  }

  // Search Logic (Updated)
  void filterReports(String query) {
    if (query.isEmpty) {
      searchList.assignAll(reportPageDataList);
    } else {
      searchList.assignAll(
        reportPageDataList.where((report) {
          return (report.propertyName ?? "").toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList(),
      );
    }
  }

  void uiToggleSearch() {
    isSearchActive.value = true;
  }

  void uiCloseSearch() {
    isSearchActive.value = false;
    searchController.clear();
    searchList.assignAll(reportPageDataList);
  }

  void updateSearchText(String value) {
    filterReports(value);
  }

  Future<void> syncOfflineReport(ReportModel report) async {
    // Sync Logic
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showWarningSnackBar(message: 'Please check internet connection');
      return;
    }

    try {
      // Decode damages
      List<Map<String, dynamic>> damagesForApi = [];
      if (report.damages != null) {
        List<dynamic> storedDamages = jsonDecode(report.damages!);
        for (var item in storedDamages) {
          Uint8List? imageBytes;
          if (item['image'] != null) {
            imageBytes = base64Decode(item['image']);
          }
          damagesForApi.add({
            'damage_name': item['damage_name'],
            'image': imageBytes,
          });
        }
      }
      overlay.show();
      String? videoUrl;
      if (report.scanVideoPath != null && report.scanVideoPath!.isNotEmpty) {
        try {
          File videoFile = File(report.scanVideoPath!);
          if (videoFile.existsSync()) {
            //overlay.show(); // Ensure overlay is shown during upload
            videoUrl = await AzureStorageService.uploadVideo(videoFile);
            if (videoUrl == null) {
              throw Exception("Failed to upload video to Azure");
            }
          }
        } catch (e) {
          overlay.hide();
          showSnackBar(isError: true, message: 'Video upload failed: $e');
          return;
        }
      }

      var result = await DamageRepo.uploadOfflineReport(
        bodyData: {
          'property_name': report.title,
          'property_address': report.address,
          'summary': report.summary,
          'damages': damagesForApi,
          'video_url': videoUrl,
          /*'capture_video': videoUrl == null ? report.scanVideoPath : null,*/
        },
      );

      overlay.hide();

      if (result["success"] == true) {
        // Delete from local DB
        if (report.id != null) {
          await DatabaseHelper.instance.deleteReport(report.id!);
        }
        // Refresh lists
        getOfflineReports();
        getReportPageList();
      }
    } catch (e) {
      isLoadingReport.value = false;
      overlay.hide();
      showSnackBar(isError: true, message: 'Sync failed: $e');
    }
  }
}

class NavigationHelper {
  static Future<void> goToDashboardTabThenScreen({
    required int tabIndex,
  }) async {
    // Step 1: Go to Dashboard
    if (Get.currentRoute != Routes.DASHBOARD) {
      Get.offAll(() => DashBoardView());
    } else {
      // Already on dashboard, just change tab
      final controller = Get.find<DashboardController>();
      // controller.changeTab(tabIndex);
    }
  }
}
