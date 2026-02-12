import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Future<Map<Permission, PermissionStatus>> requestMultiplePermissions() async {
//   final permissions = <Permission>[
//     Permission.camera,
//     Permission.microphone,
//   ];
//
//   // Request all at once — returns Map<Permission, PermissionStatus>
//   final statuses = await permissions.request();
//   return statuses;
// }
//
// /// Example helper that checks and handles results
// Future<bool> ensurePermissionsForFeature(BuildContext context) async {
//   final statuses = await requestMultiplePermissions();
//
//   // If all required permissions are granted:
//   final allGranted = statuses.values.every((s) => s.isGranted || s.isLimited);
//   if (allGranted) return true;
//
//   // If any permission is permanentlyDenied, ask user to open app settings
//   final anyPermanentlyDenied = statuses.values.any(
//         (s) => s.isPermanentlyDenied,
//   );
//   if (anyPermanentlyDenied) {
//     // Show dialog guiding user to settings
//     final open = await showDialog<bool>(
//       context: context,
//       builder: (c) => AlertDialog(
//         title: Text('Permissions required'),
//         content: Text(
//           'Some permissions are permanently denied. Open app settings to enable them.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(c, false),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(c, true),
//             child: Text('Open settings'),
//           ),
//         ],
//       ),
//     );
//     if (open == true) {
//       await openAppSettings();
//     }
//     return false;
//   }
//
//   // Some may be denied (but not permanently). You can prompt again or show rationale.
//   final denied = statuses.entries.where((e) => e.value.isDenied).toList();
//   if (denied.isNotEmpty) {
//     // Optionally show rationale UI and re-request
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Please grant permissions to use this feature.'),
//       ),
//     );
//     return false;
//   }
//
//   return false;
// }



Future<bool> ensurePermissionsForFeature(BuildContext context) async {
  final permissions = <Permission>[
    Permission.camera,
    Permission.microphone,
  ];

  // Check current status first
  final currentStatuses = await Future.wait(
    permissions.map((p) => p.status),
  );

  // If permanently denied, go to settings
  if (currentStatuses.any((s) => s.isPermanentlyDenied)) {
    return await _openSettingsWithDialog(context);
  }

  // Request permissions
  final statuses = await permissions.request();

  // If all granted, proceed
  if (statuses.values.every((s) => s.isGranted || s.isLimited)) {
    return true;
  }

  // If any permanently denied after request, go to settings
  if (statuses.values.any((s) => s.isPermanentlyDenied)) {
    return await _openSettingsWithDialog(context);
  }

  // Otherwise show message
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All permissions are required to continue'),
      ),
    );
  }

  return false;
}

Future<bool> _openSettingsWithDialog(BuildContext context) async {
  final shouldOpen = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Permissions Required'),
      content: const Text(
        'Please enable Camera, Microphone, and Notifications in Settings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Open Settings'),
        ),
      ],
    ),
  ) ?? false;

  if (shouldOpen) {
    await openAppSettings();
  }

  return false;
}