import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_scan_pro/screens/Settings/controller/settings_controller.dart';
import 'package:property_scan_pro/utils/Extentions.dart';
import 'package:property_scan_pro/utils/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Environment/core/core_config.dart';
import '../../../components/app_bar.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_textstyle.dart';
import '../../../widgets/custom_widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var settingController = Get.put(SettingsController());
  bool notificationsEnabled = true;
  @override
  void initState() {
    settingController.getDataProfile();
    super.initState();
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: scaffoldColor,
  //     appBar: PreferredSize(
  //       preferredSize: Size.fromHeight(7.h),
  //       child: AppBar(
  //         automaticallyImplyLeading: false,
  //         flexibleSpace: Container(color: white),
  //         elevation: 0,
  //         title: "Settings"
  //             .customText(
  //           color: white,
  //           size: 15.sp,
  //           fontWeight: FontWeight.w500,
  //         )
  //             .gradient(AppGradients.primaryGradient),
  //       ),
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           // Edit Profile Card
  //         _buildCard(
  //           child: InkWell(
  //             onTap: () {
  //               Get.toNamed(Routes.EDITPROFILE);
  //             },
  //             borderRadius: BorderRadius.circular(24),
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Row(
  //                 children: [
  //                    Obx(
  //                   ()=> CircleAvatar(
  //                       radius: 32,
  //                       backgroundImage: NetworkImage(
  //                       settingController.profileImage.value,
  //                       ),
  //                                          ),
  //                    ),
  //                   const SizedBox(width: 16),
  //                   const Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Edit Profile',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         SizedBox(height: 4),
  //                         Text(
  //                           'Edit your profile',
  //                           style: TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.grey,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const Icon(
  //                     Icons.chevron_right,
  //                     color: Colors.grey,
  //                     size: 28,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //           const SizedBox(height: 16),
  //
  //           // Notifications Card
  //           _buildSettingCard(
  //             icon: Icons.notifications_outlined,
  //             title: 'Notifications',
  //             subtitle: 'Turn on/off notifications',
  //             trailing: _buildSwitch(),
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Storage & Data Card
  //           _buildSettingCard(
  //             icon: Icons.storage_outlined,
  //             title: 'Storage & Data',
  //             subtitle: 'Manage storage and data usage',
  //             trailing: _buildCleanStorageButton(),
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Subscription Plans Card
  //           _buildSettingCard(
  //             icon: Icons.card_membership_outlined,
  //             title: 'Subscription Plans',
  //             subtitle: 'Current Plan - Pro',
  //             trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
  //             onTap: () {
  //               Get.toNamed(Routes.SUBSCRIPTION);
  //             },
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Privacy Policy Card
  //           _buildSettingCard(
  //             icon: Icons.privacy_tip_outlined,
  //             title: 'Privacy Policy',
  //             subtitle: 'Read our privacy policy',
  //             trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
  //             onTap: () {
  //               Get.toNamed(
  //                   Routes.COMMONCMSVIEW,
  //                   arguments: "privacy-policy"
  //               );
  //               // Navigate to privacy policy
  //             },
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Terms & Conditions Card
  //           _buildSettingCard(
  //             icon: Icons.description_outlined,
  //             title: 'Terms & Conditions',
  //             subtitle: 'Read terms and conditions',
  //             trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
  //             onTap: () {
  //               Get.toNamed(
  //                   Routes.COMMONCMSVIEW,
  //                   arguments: "term-and-condition"
  //               );
  //               // Navigate to terms & conditions
  //             },
  //           ),
  //           const SizedBox(height: 16),
  //           _buildSettingCard(
  //             icon: Icons.question_answer,
  //             title: 'FAQs',
  //             subtitle: 'Read FAQs',
  //             trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
  //             onTap: () {
  //               Get.toNamed(
  //                   Routes.FAQVIEW,
  //               );
  //               // Navigate to terms & conditions
  //             },
  //           ),
  //           const SizedBox(height: 24),
  //
  //           // Delete Account Button
  //           _buildDeleteAccountButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSettingCard({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   Widget? trailing,
  //   VoidCallback? onTap,
  // }) {
  //   return _buildCard(
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(24),
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Row(
  //           children: [
  //             _buildIconContainer(icon),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     subtitle,
  //                     style: const TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             if (trailing != null) trailing,
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCard({required Widget child}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.orange.withOpacity(0.1),
  //           blurRadius: 20,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: child,
  //   );
  // }
  //
  // Widget _buildIconContainer(IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.orange.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: ShaderMask(
  //       blendMode: BlendMode.srcIn,
  //       shaderCallback: (bounds) => const LinearGradient(
  //         colors: [Color(0xFF5B4FE9), Color(0xFF8B5CF6)],
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //       ).createShader(
  //         Rect.fromLTWH(0, 0, bounds.width, bounds.height),
  //       ),
  //       child: Icon(
  //         icon,
  //         size: 24,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildSwitch() {
  //   return Transform.scale(
  //     scale: 0.9,
  //     child: Switch(
  //       value: notificationsEnabled,
  //       onChanged: (value) {
  //         setState(() {
  //           notificationsEnabled = value;
  //         });
  //       },
  //       activeColor: primaryColor,
  //     ),
  //   );
  // }
  //
  // Widget _buildCleanStorageButton() {
  //   return InkWell(
  //     onTap: () {
  //       // Handle clean storage
  //       _showCleanStorageDialog();
  //     },
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 8,
  //       ),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF5F5F5),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: const Text(
  //         'Clean Storage',
  //         style: TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w600,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildDeleteAccountButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 56,
  //     child: OutlinedButton(
  //       onPressed: () {
  //         _showDeleteAccountDialog();
  //       },
  //       style: OutlinedButton.styleFrom(
  //         side: const BorderSide(color: Colors.red, width: 2),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(28),
  //         ),
  //       ),
  //       child: const Text(
  //         'Logout Account',
  //         style: TextStyle(
  //           color: Colors.red,
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(26.h),
        child: SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: const BoxDecoration(
              color: AppColors.cardBg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Settings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 20.sp, // responsive text
                  ),
                ),
                SizedBox(height: 2.h),
                _buildProfileCard(),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildSectionHeader("ACCOUNT"),
              _buildSectionContainer([
                _buildSettingItem(
                  icon: Icons.person_outline,
                  title: "Profile Settings",
                  iconColor: Colors.cyan,
                  onTapItem: () async {
                    if (!await checkInternetConnection()) return;
                    Get.toNamed(Routes.EDITPROFILE);
                  }
                ),
                const Divider(color: AppColors.divider, height: 1),
        _buildSettingItemSwitch(
          icon: Icons.notifications_none,
          title: "Notifications",
          iconColor: Colors.cyan,
          switchValue: true,
          onSwitchChanged: (value) {
          },
          badgeCount: 3,
          onTapItem: () {},
        ),
                _buildSettingItem(
                    icon: Icons.subscriptions,
                    title: "Subscriptions & Plan",
                    iconColor: Colors.red,
                    onTapItem: () async {
                      if (!await checkInternetConnection()) return;
                      Get.toNamed(
                        Routes.SUBSCRIPTION,
                      );
                    }
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionHeader("LEGAL"),
              _buildSectionContainer([
                _buildSettingItem(
                  icon: Icons.security,
                  title: "Privacy & Policy",
                  iconColor: Colors.green,
                  onTapItem: () async {
                    if (!await checkInternetConnection()) return;
                    Get.toNamed(
                        Routes.COMMONCMSVIEW,
                        arguments: "privacy-policy"
                    );
                  }
                ),
                _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: "Terms & Conditions",
                    iconColor: Colors.blue,
                    onTapItem: () async {
                      if (!await checkInternetConnection()) return;
                      Get.toNamed(
                                            Routes.COMMONCMSVIEW,
                                            arguments: "term-and-condition"
                                        );
                    }
                ),
                _buildSettingItem(
                    icon: Icons.question_answer_outlined,
                    title: "Faqs",
                    iconColor: Colors.orange,
                    onTapItem: () async {
                      if (!await checkInternetConnection()) return;
                      Get.toNamed(
                          Routes.FAQVIEW,
                      );
                    }
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader("SUPPORT"),
              _buildSectionContainer([
                _buildSettingItem(
                    icon: Icons.contact_support,
                    title: "Support",
                    iconColor: Colors.green,
                    onTapItem: () async {
                      if (!await checkInternetConnection()) return;
                      // Get.toNamed(
                      //     Routes.COMMONCMSVIEW,
                      //     arguments: "privacy-policy"
                      // );
                    }
                ),
                _buildSettingItem(
                    icon: Icons.info,
                    title: "About Property Scan Pro",
                    iconColor: Colors.blue,
                    onTapItem: () async {
                      if (!await checkInternetConnection()) return;
                      // Get.toNamed(
                      //     Routes.COMMONCMSVIEW,
                      //     arguments: "term-and-condition"
                      // );
                    }
                ),
              ]),
              const SizedBox(height: 24),
              _buildVersionCard(),
              const SizedBox(height: 24),
              Obx(()=>settingController.isLoadingLogOut.value ? CircularProgressIndicator().centerExtension(): _buildLogoutButton()),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Obx(
        ()=>settingController.isLoadingProfile.value?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: AppColors.cardBg,
            highlightColor: Colors.grey.shade700,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
            ),
          ),
        ): Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color:AppColors.fieldBorder)
        ),
        child: Row(
          children: [
           CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(
                                  settingController.profileImage.value,
                                  ),
                                                     ),

            const SizedBox(width: 16),
             Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(settingController.profileDataGetList.value.name??"User Name", style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(settingController.profileDataGetList.value.email??"User Email", style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.textSecondary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    int? badgeCount,
    void Function()? onTapItem,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16), // 👈 important
      onTap: onTapItem,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24,),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeCount != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
        //onTap: onTapItem,
      ),
    );
  }

  Widget _buildVersionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "PropertyScan Version",
            style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(Config.appVersion, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () async {
        if (!await checkInternetConnection()) return;
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.85),
          builder: (context) => ConfirmationDialog(
            title: 'Log Out',
            message: 'Are you sure you want to log out of PropertyScan Pro?',
            cancelText: 'Cancel',
            confirmText: 'Log Out',
            confirmButtonColor: const Color(0xFFEF4444),
            onConfirm: () async {
              if (!await checkInternetConnection()) return;
              settingController.logoutUser();
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.error.withOpacity(0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error),
            const SizedBox(width: 12),
            Text(
              "Log Out",
              style: AppTextStyles.titleSmall.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSettingItemSwitch({
    required IconData icon,
    required String title,
    required Color iconColor,

    // 🔸 Badge
    int? badgeCount,

    // 🔸 Switch
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,

    VoidCallback? onTapItem,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: AppTextStyles.bodyLarge),

      trailing: _buildTrailing(
        badgeCount: badgeCount,
        switchValue: switchValue,
        onSwitchChanged: onSwitchChanged,
      ),

      // Disable tile tap when switch exists
      onTap: switchValue != null ? null : onTapItem,
    );
  }
  Widget _buildTrailing({
    int? badgeCount,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    // ✅ Switch has highest priority
    if (switchValue != null) {
      return Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: AppColors.primary,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (badgeCount != null)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Text(
              badgeCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
      ],
    );
  }

  void _showCleanStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Clean Storage'),
        content: const Text(
          'Are you sure you want to clean storage? This will remove cached data and temporary files.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform clean storage action
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Storage cleaned successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clean',style: TextStyle(color: white),),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout Account',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(
          ()=> settingController.isLoadingLogOut.value ? CircularProgressIndicator().centerExtension():  ElevatedButton(
              onPressed: () {
                settingController.logoutUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('LogOut',style: TextStyle(color: white),),
            ),
          ),
        ],
      ),
    );
  }
}