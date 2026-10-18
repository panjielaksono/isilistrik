import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'config/colors.dart';
import 'services/data_service.dart';
import 'ui/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inject Logic Service ke seluruh aplikasi
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: MaterialApp(
        title: 'IsiListrik Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.robotoTextTheme(), // Pakai font Roboto
          useMaterial3: true,
        ),
        // Update: Sekarang mengarah ke Login Screen
        home: const LoginScreen(),
      ),
    );
  }
}
