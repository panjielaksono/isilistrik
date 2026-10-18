import 'package:flutter/material.dart';
import '../models/meter_model.dart';
import '../models/transaction_model.dart';

class DataService extends ChangeNotifier {
  // --- STATE (DATA) ---

  // User Info (Hardcode dulu kayak di JS)
  String userName = "Pengguna Demo";

  // List Devices (Default Data)
  final List<MeterModel> _devices = [
    MeterModel(id: "141200001", name: "Rumah Utama", kwh: 12.50, icon: "house"),
    MeterModel(
      id: "141200002",
      name: "Kosan Bandung",
      kwh: 145.20,
      icon: "building",
    ),
  ];

  // List History
  final List<TransactionModel> _transactions = [
    TransactionModel(
      desc: "Isi Token 50k",
      date: "20 Okt, Kosan Bandung",
      kwhAdded: "+33.5",
      status: "Sukses",
    ),
    TransactionModel(
      desc: "Isi Token 20k",
      date: "15 Okt, Rumah Utama",
      kwhAdded: "+13.2",
      status: "Sukses",
    ),
    TransactionModel(
      desc: "Isi Token 100k",
      date: "01 Okt, Rumah Utama",
      kwhAdded: "+67.1",
      status: "Sukses",
    ),
  ];

  // Current Selection (State Carousel)
  int _currentDeviceIndex = 0;

  // --- GETTERS (Biar UI bisa baca data) ---
  List<MeterModel> get devices => _devices;
  List<TransactionModel> get transactions => _transactions;
  int get currentIndex => _currentDeviceIndex;

  // Helper: Ambil device yang lagi aktif di carousel
  MeterModel get activeDevice =>
      _devices.isNotEmpty
          ? _devices[_currentDeviceIndex]
          : MeterModel(id: "0", name: "No Device", kwh: 0);

  // --- ACTIONS (Logic Aplikasi) ---

  // 1. Ganti slide carousel
  void setCurrentIndex(int index) {
    _currentDeviceIndex = index;
    notifyListeners(); // Kabari UI untuk update tombol/status
  }

  // 2. Tambah / Edit Device (CRUD)
  void saveDevice({
    required String id,
    required String name,
    int? indexToEdit,
  }) {
    if (indexToEdit != null && indexToEdit >= 0) {
      // Edit Mode
      _devices[indexToEdit].name = name;
      _devices[indexToEdit].id = id;
    } else {
      // Add New Mode
      _devices.add(MeterModel(id: id, name: name, kwh: 0.00, icon: 'bolt'));
    }
    notifyListeners();
  }

  // 3. Hapus Device
  void deleteDevice(int index) {
    _devices.removeAt(index);
    if (_currentDeviceIndex >= _devices.length) {
      _currentDeviceIndex = 0; // Reset index kalo yang dihapus slide terakhir
    }
    notifyListeners();
  }

  // 4. Proses Topup (Checkout Logic)
  void processTopUp(int amount, double kwhReceived) {
    // Update Saldo Device Aktif
    MeterModel target = activeDevice;
    target.kwh += kwhReceived;
    target.isCritical = false; // Reset status kritis

    // Catat Transaksi
    String nominalK = "${amount ~/ 1000}k"; // 50000 -> 50k
    _transactions.insert(
      0,
      TransactionModel(
        desc: "Isi Token $nominalK",
        date: "Baru saja, ${target.name}",
        kwhAdded: "+$kwhReceived",
        status: "Sukses",
      ),
    );

    notifyListeners();
  }

  // 5. Toggle Critical (Buat Demo)
  void toggleCritical() {
    if (_devices.isNotEmpty) {
      _devices[_currentDeviceIndex].isCritical =
          !_devices[_currentDeviceIndex].isCritical;
      notifyListeners();
    }
  }
}
