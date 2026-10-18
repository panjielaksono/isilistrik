import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/colors.dart';
import '../../models/meter_model.dart';

class MeterCard extends StatelessWidget {
  final MeterModel data;
  final VoidCallback? onTap;

  const MeterCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Logic warna background (Blue vs Red)
    final gradientColors =
        data.isCritical
            ? [AppColors.danger, const Color(0xFFb91c1c)] // Merah
            : [AppColors.primary, AppColors.primaryDark]; // Biru

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header: Icon + Nama + ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          // Mapping string icon ke FaIcon
                          data.icon == 'building'
                              ? FontAwesomeIcons.building
                              : FontAwesomeIcons.house,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "ID: ${data.id}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Body: Besar kWh
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sisa Daya Listrik",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data.kwh.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            "kWh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Footer: Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        data.isCritical
                            ? FontAwesomeIcons.triangleExclamation
                            : FontAwesomeIcons.circleCheck,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data.isCritical ? "Status: Kritis!" : "Status: Aman",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
