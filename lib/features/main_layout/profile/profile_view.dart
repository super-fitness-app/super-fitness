import 'dart:io';
import 'package:flutter/material.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/session/user_profile_notifier.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const List<String> presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionService = getIt.isRegistered<SessionService>()
        ? getIt<SessionService>()
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(l10n.profile, style: AppTextStyles.headline24),
              const SizedBox(height: 36),

              // Profile Avatar with Camera Button
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: UserProfileNotifier.userPhoto,
                      builder: (context, photo, _) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2.5,
                            ),
                          ),
                          child: ClipOval(
                            child: _buildAvatarImage(photo),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: GestureDetector(
                        onTap: () => _showChangePhotoDialog(context, sessionService),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Change Photo Action Button
              TextButton.icon(
                onPressed: () => _showChangePhotoDialog(context, sessionService),
                icon: const Icon(Icons.edit, color: AppColors.primaryColor, size: 18),
                label: const Text(
                  'Change Photo',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarImage(String? photoUrl) {
    if (photoUrl == null || photoUrl.trim().isEmpty) {
      return Image.asset(
        AppImages.defaultAvatar,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    final url = photoUrl.trim();
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    } else if (url.startsWith('/') || url.startsWith('file://')) {
      final path = url.startsWith('file://')
          ? url.replaceFirst('file://', '')
          : url;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    } else {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppImages.defaultAvatar,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    }
  }

  void _showChangePhotoDialog(BuildContext context, SessionService? sessionService) {
    final textController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose a preset avatar:',
                style: TextStyle(color: AppColors.grey40, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Option to reset to default solid avatar
                  GestureDetector(
                    onTap: () {
                      UserProfileNotifier.updatePhoto('', sessionService);
                      Navigator.pop(bottomSheetContext);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.grey50, width: 1.5),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.defaultAvatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Preset avatars
                  ...presetAvatars.map(
                    (avatar) => GestureDetector(
                      onTap: () {
                        UserProfileNotifier.updatePhoto(avatar, sessionService);
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.grey50, width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.surface,
                              child: const Icon(
                                Icons.person,
                                color: AppColors.grey40,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Or enter image URL',
                  hintStyle: const TextStyle(color: AppColors.grey40),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final url = textController.text.trim();
                    if (url.isNotEmpty) {
                      UserProfileNotifier.updatePhoto(url, sessionService);
                    }
                    Navigator.pop(bottomSheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Photo',
                    style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
