import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_roomplan/flutter_roomplan.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:property_scan_pro/screens/3DWalkthrough/repo/three_d_repo.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/full_screen_loader.dart';
import '../model/three_d_list_model.dart';

class ThreeDWalkthroughController extends GetxController{

  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController propertyAddressController = TextEditingController();
  var isCurrentModels = [];
  var overlay = LoadingOverlay();

  final FlutterRoomplan flutterRoomplan = FlutterRoomplan();
  var isSupported = false.obs;
  bool isMultiRoomSupported = false;
  String? usdzFilePath;
  String? jsonFilePath;
  var currentModels = [];
  var isLoadingModel = false.obs,isLoadingModelList = false.obs;
  var  threeDList = <ThreeDModelData>[].obs;

  Future<void> checkSupport() async {
    final isSupported = await flutterRoomplan.isSupported();
    final isMultiRoomSupported = await flutterRoomplan.isMultiRoomSupported();

      this.isSupported.value = isSupported;
      this.isMultiRoomSupported = isMultiRoomSupported;

  }

  double? _areaSqM; // area in square meters
  double? _areaSqFt; // area in square feet
  String? _error;
  double? lengthMeters;
  double? heightMeters;
  double? widthMeters;

  Future<void> readAndComputeArea(String jsonPath) async {
    try {
      final file = File(jsonPath);
      if (!await file.exists()) {

          _error = 'JSON file not found at path:\n$jsonPath';

        return;
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final result = _computeAreaFromRoomPlanJson(data);


        _areaSqM = result?.$1;
        _areaSqFt = result?.$2;
        if (_areaSqM == null || _areaSqFt == null) {
          _error = 'Could not compute area from JSON.';
        } else {
          _error = null;
        }

    } catch (e, st) {
      debugPrint('Error reading / parsing JSON: $e\n$st');

        _error = 'Error reading JSON: $e';

    }
  }

  /// Returns (areaSqM, areaSqFt) or null if failed.
  ///
  /// Uses polygonCorners first (more accurate), otherwise falls back to dimensions.
  (double, double)? _computeAreaFromRoomPlanJson(Map<String, dynamic> data) {
    // constants
    const sqmToSqft = 10.76391041671;

    final floors = data['floors'];
    if (floors == null || floors is! List || floors.isEmpty) {
      debugPrint('No floors in JSON');
      return null;
    }

    final firstFloor = floors.first as Map<String, dynamic>?;

    if (firstFloor == null) return null;

    // 1. Try polygonCorners if present
    final corners = firstFloor['polygonCorners'];
    if (corners is List && corners.length >= 3) {
      final areaSqM = _polygonAreaSqMFromCorners(corners);
      final areaSqFt = areaSqM * sqmToSqft;
      debugPrint('Area from polygonCorners: ${areaSqM.round()} m²');
      //debugPrint('Area from polygonCorners: ${areaSqM.round()} m² / $areaSqFt ft²');
      return (areaSqM, areaSqFt);
    }

    // 2. Fall back to dimensions (length * width)
    final dims = firstFloor['dimensions'];
    if (dims is! List || dims.length < 2) {
      debugPrint('dimensions missing or invalid');
      return null;
    }

    final double lengthM = (dims[0] as num).toDouble();
    final double widthM = (dims[1] as num).toDouble();

    final double areaSqM = lengthM * widthM;
    final double areaSqFt = areaSqM * sqmToSqft;

    debugPrint('Area from dimensions: ${areaSqM.round()} m²');
    //debugPrint('Area from dimensions: ${areaSqM.round()} m² / $areaSqFt ft²');

    return (areaSqM, areaSqFt);
  }

  double _polygonAreaSqMFromCorners(List corners) {
    if (corners.length < 3) return 0;

    double sum = 0;
    for (int i = 0; i < corners.length; i++) {
      final current = corners[i] as List;
      final next = corners[(i + 1) % corners.length] as List;

      final double x1 = (current[0] as num).toDouble();
      final double y1 = (current[1] as num).toDouble();
      final double x2 = (next[0] as num).toDouble();
      final double y2 = (next[1] as num).toDouble();

      sum += (x1 * y2) - (x2 * y1);
    }
    return sum.abs() / 2.0; // area in m²
  }



  Future<void> calculateAreaFromJson(String jsonPath) async {
    try {
      // 1. Read file
      final file = File(jsonPath);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      print('=== ROOM AREA CALCULATION ===\n');

      // 2. Calculate WALL areas
      double totalWallAreaSqMeters = 0.0;

      if (data['walls'] != null && (data['walls'] as List).isNotEmpty) {
        final walls = data['walls'] as List;
        print('--- WALLS (${walls.length} total) ---');

        for (int i = 0; i < walls.length; i++) {
          final wall = walls[i] as Map<String, dynamic>;
          final dimensions = wall['dimensions'] as List;

          // dimensions array: [length, height, width]
         lengthMeters = (dimensions[0] as num).toDouble();
           heightMeters = (dimensions[1] as num).toDouble();
           widthMeters = (dimensions[2] as num).toDouble();

          // Calculate area (length × height for a wall)
          final double areaSqMeters = lengthMeters! * heightMeters!;
          totalWallAreaSqMeters += areaSqMeters;

          // Convert to sq ft
          const double sqmToSqft = 10.76391041671;
          final double areaSqFeet = areaSqMeters * sqmToSqft;

          print('Wall ${i + 1}:');
          print('  Dimensions: ${lengthMeters?.toStringAsFixed(2)}m × ${heightMeters?.toStringAsFixed(2)}m');
          print('  Area: ${areaSqMeters.toStringAsFixed(2)} m² (${areaSqFeet.toStringAsFixed(2)} ft²)');
          print('');
        }
      } else {
        print('No walls found in JSON\n');
      }

      // 3. Calculate FLOOR areas
      double totalFloorAreaSqMeters = 0.0;

      if (data['floors'] != null && (data['floors'] as List).isNotEmpty) {
        final floors = data['floors'] as List;
        print('--- FLOORS (${floors.length} total) ---');

        for (int i = 0; i < floors.length; i++) {
          final floor = floors[i] as Map<String, dynamic>;
          final dimensions = floor['dimensions'] as List;

          // dimensions array: [length, width, height]
          final double lengthMeters = (dimensions[0] as num).toDouble();
          final double widthMeters = (dimensions[1] as num).toDouble();
          final double heightMeters = (dimensions[2] as num).toDouble();

          // Calculate area (length × width for a floor)
          final double areaSqMeters = lengthMeters * widthMeters;
          totalFloorAreaSqMeters += areaSqMeters;

          // Convert to sq ft
          const double sqmToSqft = 10.76391041671;
          final double areaSqFeet = areaSqMeters * sqmToSqft;

          print('Floor ${i + 1}:');
          print('  Dimensions: ${lengthMeters.toStringAsFixed(2)}m × ${widthMeters.toStringAsFixed(2)}m');
          print('  Area: ${areaSqMeters.toStringAsFixed(2)} m² (${areaSqFeet.toStringAsFixed(2)} ft²)');
          print('');
        }
      } else {
        print('No floors found in JSON\n');
      }

      // 4. Calculate TOTALS
      const double sqmToSqft = 10.76391041671;

      print('═══════════════════════════════════');
      print('TOTALS:');
      print('═══════════════════════════════════');
      print('Total Wall Area:  ${totalWallAreaSqMeters.toStringAsFixed(2)} m² (${(totalWallAreaSqMeters * sqmToSqft).toStringAsFixed(2)} ft²)');
      print('Total Floor Area: ${totalFloorAreaSqMeters.toStringAsFixed(2)} m² (${(totalFloorAreaSqMeters * sqmToSqft).toStringAsFixed(2)} ft²)');
      print('───────────────────────────────────');

      final double grandTotalSqMeters = totalWallAreaSqMeters + totalFloorAreaSqMeters;
      final double grandTotalSqFeet = grandTotalSqMeters * sqmToSqft;

      print('GRAND TOTAL:      ${grandTotalSqMeters.toStringAsFixed(2)} m² (${grandTotalSqFeet.toStringAsFixed(2)} ft²)');
      print('═══════════════════════════════════\n');

    } catch (e, stackTrace) {
      print('Error calculating area: $e');
      print('Stack trace: $stackTrace');
    }
  }
  @override
  void onInit() {
    super.onInit();
    _extractArguments();
  }
  void _extractArguments() {
    final dynamic args = Get.arguments;
    // Map data was passed
    if (args != null && args is Map) {
      isCurrentModels = args['currentModels'] ?? [];
    } else {
      isCurrentModels = []; // Default value
    }

  }

  Future<void> addThreeDModelApi({var bodyData}) async {
    isLoadingModel.value = true;
    overlay.show();
    isLoadingModel.value = await ThreeDRepo.addThreeDModel(
        bodyData: bodyData);
  }

  Future<void> getThreeDList() async {
    threeDList.value.clear();
    isLoadingModelList.value = true;
    isLoadingModelList.value = await ThreeDRepo.getThreeDListPage();
    if (ThreeDRepo.threeDListData != null) {
      threeDList.value = ThreeDRepo.threeDListData;
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
  VideoPlayerController? videoPlayerController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  Future<void> initializeVideo(String videoUrl) async {
    try {
      isLoading.value = true;

      videoPlayerController = VideoPlayerController.network(videoUrl);

      await videoPlayerController!.initialize();

      isInitialized.value = true;
      totalDuration.value = videoPlayerController!.value.duration;

      // Listen to position changes
      videoPlayerController!.addListener(() {
        currentPosition.value = videoPlayerController!.value.position;
        isPlaying.value = videoPlayerController!.value.isPlaying;
      });

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load video: $e');
    }
  }

  void playPause() {
    if (videoPlayerController != null && isInitialized.value) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
    }
  }

  void seekTo(Duration position) {
    videoPlayerController?.seekTo(position);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }


}