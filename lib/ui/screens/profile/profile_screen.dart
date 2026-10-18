import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../services/data_service.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';
import 'manage_device_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, data, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // --- PROFILE HEADER ---
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=33",
                    ),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    data.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const Text(
                    "user@example.com", // Email dummy
                    style: TextStyle(color: AppColors.textMuted),
                  ),

                  const SizedBox(height: 30),

                  // --- MENU LIST ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _menuItem(
                          context,
                          title: "Kelola Meteran",
                          icon: FontAwesomeIcons.houseLaptop,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageDeviceScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _menuItem(
                          context,
                          title: "Keamanan Akun",
                          icon: FontAwesomeIcons.shieldHalved,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Fitur Dummy")),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _menuItem(
                          context,
                          title: "Bantuan & CS",
                          icon: FontAwesomeIcons.circleQuestion,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Fitur Dummy")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- LOGOUT BUTTON ---
                  CustomButton(
                    text: "Keluar Aplikasi",
                    color: const Color(0xFFFEE2E2),
                    textColor: AppColors.danger,
                    onPressed: () {
                      // Logout Logic: Clear stack dan balik ke Login
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: FaIcon(icon, size: 18, color: AppColors.textMuted),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      trailing: const FaIcon(
        FontAwesomeIcons.chevronRight,
        size: 14,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
