import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: controller.navigateToSettings,
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.user.value == null) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          final user = controller.user.value;

          if (user == null) {
            return const Center(
              child: Text('No profile data available'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: user.avatar != null
                            ? ClipOval(
                                child: Image.network(
                                  user.avatar!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bio card
                      if (user.bio != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bio',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(user.bio!),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Contact information
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              ListTile(
                                leading: const Icon(Icons.email_outlined),
                                title: const Text('Email'),
                                subtitle: Text(user.email),
                                contentPadding: EdgeInsets.zero,
                              ),

                              // Phone
                              if (user.phone != null)
                                ListTile(
                                  leading: const Icon(Icons.phone_outlined),
                                  title: const Text('Phone'),
                                  subtitle: Text(user.phone!),
                                  contentPadding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Edit profile button
                      CustomButton(
                        text: 'Edit Profile',
                        onPressed: controller.navigateToEditProfile,
                        icon: Icons.edit,
                      ),
                      const SizedBox(height: 12),

                      // Logout button
                      CustomButton(
                        text: 'Logout',
                        onPressed: controller.logout,
                        isOutlined: true,
                        color: Colors.red,
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
