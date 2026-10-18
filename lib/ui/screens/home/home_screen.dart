import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../services/data_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/history_tile.dart';
import '../../widgets/meter_card.dart';
import '../../widgets/section_title.dart';
import '../checkout/checkout_screen.dart';
import '../profile/manage_device_screen.dart';
// import '../profile/manage_device_screen.dart'; // Nanti di-uncomment

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk Carousel (Viewport 0.9 biar card sebelah agak nongol dikit)
  final PageController _pageController = PageController(viewportFraction: 0.92);

  @override
  Widget build(BuildContext context) {
    // Consumer mendengarkan perubahan di DataService
    return Consumer<DataService>(
      builder: (context, data, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. HEADER ---
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?img=33",
                              ),
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Selamat Pagi,",
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  data.userName, // Nama dari DataService
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {}, // Nanti buat notif
                          icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
                        ),
                      ],
                    ),
                  ),

                  // --- 2. CAROUSEL METERAN ---
                  SizedBox(
                    height: 220, // Tinggi area carousel
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        // Update state index di DataService saat slide digeser
                        data.setCurrentIndex(index);
                      },
                      // Jumlah item = jumlah device + 1 (kartu "Add New")
                      itemCount: data.devices.length + 1,
                      itemBuilder: (context, index) {
                        // Jika index terakhir, render kartu "Add New"
                        if (index == data.devices.length) {
                          return _buildAddCard(context);
                        }
                        // Render Kartu Meteran
                        return MeterCard(
                          data: data.devices[index],
                          onTap: () {
                            data.toggleCritical(); // Demo: Klik card buat toggle status kritis
                          },
                        );
                      },
                    ),
                  ),

                  // --- 3. INDIKATOR DOTS ---
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(data.devices.length + 1, (index) {
                      bool isActive = index == data.currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  // --- 4. TOMBOL UTAMA (ISI TOKEN) ---
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomButton(
                      text:
                          (data.currentIndex >= data.devices.length)
                              ? "Tambah Meteran Baru" // Teks kalau lagi di slide "Add New"
                              : "Isi Token ${data.activeDevice.name}", // Teks normal
                      color:
                          AppColors
                              .warning, // Warna Kuning (#FFD700 agak beda dikit, kita pake warning)
                      textColor: AppColors.textMain,
                      onPressed:
                          (data.currentIndex >= data.devices.length)
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ManageDeviceScreen(),
                                  ),
                                );
                                // Logic tambah device (Nanti)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Fitur Tambah Device (Next Step)",
                                    ),
                                  ),
                                );
                              }
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CheckoutScreen(),
                                  ),
                                );
                                // Logic Checkout
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Masuk ke Checkout Screen (Next Step)",
                                    ),
                                  ),
                                );
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen()));
                              },
                    ),
                  ),

                  // --- 5. HISTORY SECTION ---
                  const SectionTitle(title: "Riwayat Singkat"),
                  ListView.builder(
                    shrinkWrap: true, // Biar bisa scroll bareng parent
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        data.transactions.length > 2
                            ? 2
                            : data.transactions.length, // Limit 2 item aja
                    itemBuilder: (context, index) {
                      return HistoryTile(data: data.transactions[index]);
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

  // Widget khusus untuk kartu "Tambah Meteran" (Dashed Border)
  Widget _buildAddCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 2,
          style: BorderStyle.solid,
        ), // Flutter gak support dashed native simple, pake solid abu2 aja cukup mirip
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ManageDeviceScreen()),
          );
          // Arahkan ke form add
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Buka Form Tambah Meteran")),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.circlePlus,
              color: AppColors.textMuted,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              "Tambah Meteran",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
