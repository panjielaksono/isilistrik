import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../services/data_service.dart';
import '../../widgets/history_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Hilangkan tombol back karena ini Tab utama
      ),
      body: Consumer<DataService>(
        builder: (context, data, child) {
          if (data.transactions.isEmpty) {
            return const Center(child: Text("Belum ada transaksi"));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            itemCount: data.transactions.length,
            itemBuilder: (context, index) {
              return HistoryTile(data: data.transactions[index]);
            },
          );
        },
      ),
    );
  }
}
