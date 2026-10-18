import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Untuk format Rp
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../services/data_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_title.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Data Nominal (Hardcode sesuai web)
  final List<Map<String, dynamic>> _nominals = [
    {"price": 20000, "kwh": 13.2},
    {"price": 50000, "kwh": 33.5},
    {"price": 100000, "kwh": 67.1},
    {"price": 200000, "kwh": 134.2},
  ];

  int _selectedPrice = 50000;
  double _selectedKwh = 33.5;
  String _selectedPayment = "BCA Virtual Account";
  bool _isLoading = false;

  // Helper Format Rupiah
  String formatRp(int number) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  void _handlePay() async {
    setState(() => _isLoading = true);

    // Simulasi Network Call & IoT Delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Panggil Logic DataService
    context.read<DataService>().processTopUp(_selectedPrice, _selectedKwh);

    // Pindah ke Success Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => SuccessScreen(
              deviceName: context.read<DataService>().activeDevice.name,
              paymentMethod: _selectedPayment,
            ),
      ),
    );
  }

  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pilih Metode Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _paymentOption(
                "BCA Virtual Account",
                FontAwesomeIcons.buildingColumns,
                const Color(0xFF0066FF),
              ),
              _paymentOption(
                "Mandiri VA",
                FontAwesomeIcons.buildingColumns,
                const Color(0xFFEAB308),
              ),
              _paymentOption(
                "Gopay",
                FontAwesomeIcons.wallet,
                const Color(0xFF00A0E9),
              ),
              _paymentOption(
                "QRIS",
                FontAwesomeIcons.qrcode,
                AppColors.textMain,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentOption(String name, IconData icon, Color color) {
    return ListTile(
      leading: FaIcon(icon, color: color),
      title: Text(name),
      onTap: () {
        setState(() => _selectedPayment = name);
        Navigator.pop(context);
      },
      trailing:
          _selectedPayment == name
              ? const FaIcon(FontAwesomeIcons.check, color: AppColors.success)
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data device yg lagi aktif
    final activeDevice = context.read<DataService>().activeDevice;
    final adminFee = 1500;
    final totalPrice = _selectedPrice + adminFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.textMain,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pilih Nominal",
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. DEVICE INFO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Isi Token Untuk:",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          activeDevice.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ID: ${activeDevice.id}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Pilih Nominal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // 2. GRID NOMINAL
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: _nominals.length,
                    itemBuilder: (context, index) {
                      final item = _nominals[index];
                      final isSelected = item['price'] == _selectedPrice;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPrice = item['price'];
                            _selectedKwh = item['kwh'];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFEFF6FF)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatRp(item['price']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : AppColors.textMain,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "± ${item['kwh']} kWh",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // 3. PAYMENT METHOD
                  const SectionTitle(title: "Metode Pembayaran"),
                  InkWell(
                    onTap: _showPaymentModal,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.wallet,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              _selectedPayment,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const FaIcon(
                            FontAwesomeIcons.chevronDown,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTTOM SUMMARY
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nominal Token",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    Text(
                      formatRp(_selectedPrice),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Biaya Admin",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    Text(
                      formatRp(adminFee),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: Color(0xFFEEEEEE),
                    thickness: 1,
                  ), // Garis lurus biasa
                ), // Divider dummy
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Bayar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatRp(totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: "Bayar Sekarang",
                  onPressed: _handlePay,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
