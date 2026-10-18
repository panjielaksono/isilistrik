import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../services/data_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';
import '../main_nav.dart';
// import '../main_nav.dart'; // Nanti kita uncomment pas bikin MainNav

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    // 1. Validasi Input
    if (_userController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi username dulu bos!")));
      return;
    }

    // 2. Loading Effect
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi network delay

    if (!mounted) return;

    // 3. Simpan nama user ke Global State (DataService)
    context.read<DataService>().userName = _userController.text;

    // 4. Navigasi ke Home (Placeholder dulu)
    // Nanti diganti: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav()));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNav()),
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // LOGO
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.bolt,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                "IsiListrik",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Listrik pintar untuk hidup lebih tenang. Masuk untuk melanjutkan.",
                style: TextStyle(color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Form
              CustomTextField(
                label: "No. HP / Username",
                hint: "Contoh: Rian atau 0812...",
                controller: _userController,
              ),
              CustomTextField(
                label: "Password / PIN",
                hint: "••••••",
                isPassword: true,
                controller: _passController,
              ),

              // Button
              const SizedBox(height: 10),
              CustomButton(
                text: "Masuk Aplikasi",
                onPressed: _handleLogin,
                isLoading: _isLoading,
              ),

              // Register Link
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "Daftar Sekarang",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
