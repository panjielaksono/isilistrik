import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/colors.dart';
import '../../widgets/custom_button.dart';

class SuccessScreen extends StatelessWidget {
  final String deviceName;
  final String paymentMethod;

  const SuccessScreen({
    super.key,
    required this.deviceName,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Checklist Besar
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.greenAccent, blurRadius: 20),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Token untuk $deviceName berhasil dikirim.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            Text(
              "Via $paymentMethod",
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),

            const SizedBox(height: 40),

            // Simulasi IoT Status Box
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    "IoT Connection Status",
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.wifi,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Mengupdate saldo meteran...",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: "Kembali ke Home",
              color: const Color(0xFFE0F2FE),
              textColor: AppColors.primary,
              onPressed: () {
                // Pop semua route sampai balik ke awal (MainNav)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
