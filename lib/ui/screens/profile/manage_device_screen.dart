import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../models/meter_model.dart';
import '../../../services/data_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ManageDeviceScreen extends StatefulWidget {
  const ManageDeviceScreen({super.key});

  @override
  State<ManageDeviceScreen> createState() => _ManageDeviceScreenState();
}

class _ManageDeviceScreenState extends State<ManageDeviceScreen> {
  // Controller untuk Form Modal
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  // Fungsi memunculkan Modal Tambah/Edit
  void _showFormModal({MeterModel? device, int? index}) {
    // Reset atau Isi Data Awal
    if (device != null) {
      _nameController.text = device.name;
      _idController.text = device.id;
    } else {
      _nameController.clear();
      _idController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            device == null ? "Tambah Meteran" : "Edit Meteran",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: "Nama Lokasi / Label",
                hint: "Contoh: Rumah Nenek",
                controller: _nameController,
              ),
              CustomTextField(
                label: "ID Pelanggan (PLN)",
                hint: "Contoh: 1412...",
                controller: _idController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _idController.text.isNotEmpty) {
                  // Panggil Logic DataService
                  context.read<DataService>().saveDevice(
                    id: _idController.text,
                    name: _nameController.text,
                    indexToEdit: index, // Kalau null berarti nambah baru
                  );
                  Navigator.pop(context); // Tutup Modal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil disimpan!")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, data, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
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
              "Kelola Meteran",
              style: TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.devices.length,
            itemBuilder: (context, index) {
              final device = data.devices[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    // Icon Box
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: FaIcon(
                          device.icon == 'building'
                              ? FontAwesomeIcons.building
                              : FontAwesomeIcons.house,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "ID: ${device.id}",
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions Buttons (Edit & Delete)
                    Row(
                      children: [
                        _actionBtn(
                          icon: FontAwesomeIcons.pen,
                          color: AppColors.primary,
                          bg: const Color(0xFFE0F2FE),
                          onTap:
                              () =>
                                  _showFormModal(device: device, index: index),
                        ),
                        const SizedBox(width: 10),
                        _actionBtn(
                          icon: FontAwesomeIcons.trash,
                          color: AppColors.danger,
                          bg: const Color(0xFFFEE2E2),
                          onTap: () {
                            // Konfirmasi Hapus
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text("Hapus Meteran?"),
                                    content: const Text(
                                      "Data yang dihapus tidak bisa kembali.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          data.deleteDevice(index);
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text(
                                          "Hapus",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              text: "Tambah Meteran Baru",
              onPressed:
                  () =>
                      _showFormModal(), // Panggil modal mode tambah (parameter kosong)
            ),
          ),
        );
      },
    );
  }

  // Widget kecil untuk tombol Edit/Hapus
  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: FaIcon(icon, size: 14, color: color)),
      ),
    );
  }
}
