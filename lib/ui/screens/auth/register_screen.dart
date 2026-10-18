import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 1; // 1: Input HP, 2: OTP, 3: Password
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _nextStep() {
    if (_currentStep == 1) {
      if (_contactController.text.isEmpty) return;
      // Simulasi kirim OTP
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kode OTP: 8888")));
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_otpController.text != "8888") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP Salah! Coba 8888")));
        return;
      }
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      if (_passController.text.isEmpty) return;
      // Finish Register
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun dibuat! Silakan Login.")),
      );
      Navigator.pop(context); // Balik ke Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.textMain,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Daftar Akun",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Langkah $_currentStep dari 3",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // DYNAMIC CONTENT BASED ON STEP
            if (_currentStep == 1) ...[
              CustomTextField(
                label: "No. HP atau Email",
                hint: "Contoh: 08123456789",
                controller: _contactController,
                keyboardType: TextInputType.phone,
              ),
              CustomButton(text: "Kirim Kode OTP", onPressed: _nextStep),
            ],

            if (_currentStep == 2) ...[
              CustomTextField(
                label: "Kode OTP (Cek Alert)",
                hint: "Masukkan 4 digit kode",
                controller: _otpController,
                keyboardType: TextInputType.number,
              ),
              CustomButton(text: "Verifikasi OTP", onPressed: _nextStep),
            ],

            if (_currentStep == 3) ...[
              CustomTextField(
                label: "Buat Password Baru",
                hint: "Minimal 6 karakter",
                isPassword: true,
                controller: _passController,
              ),
              CustomButton(text: "Selesai & Masuk", onPressed: _nextStep),
            ],
          ],
        ),
      ),
    );
  }
}
