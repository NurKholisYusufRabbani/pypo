import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoostSimulatorPage extends StatefulWidget {
  const BoostSimulatorPage({super.key});

  @override
  BoostSimulatorPageState createState() => BoostSimulatorPageState();
}

class BoostSimulatorPageState extends State<BoostSimulatorPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  double _growthRate = 5.0;
  double _resultAmount = 0.0;
  double _profit = 0.0;
  double _daysSaved = 0.0;
  final int _years = 1;

  @override
  void initState() {
    super.initState();
    // Tampilkan pop-up edukasi setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEducationDialog();
    });
  }

  void _showEducationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tips Simulasi"),
          content: const Text(
            "Fitur simulasi ini paling cocok digunakan jika:\n\n"
                "• Jumlah target investasimu cukup besar\n"
                "• Atau waktu impianmu masih cukup lama\n\n"
                "Karena efek pertumbuhan bunga majemuk akan lebih terasa dalam jangka panjang.",
          ),
          actions: [
            TextButton(
              child: const Text("Mengerti"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _calculateBoost() {
    double initialAmount = double.tryParse(_amountController.text) ?? 0;
    double targetAmount = double.tryParse(_targetController.text) ?? 0;

    if (initialAmount > 0 && targetAmount > 0) {
      // Perhitungan investasi dengan bunga
      double futureValue = initialAmount * pow(1 + (_growthRate / 100), _years);
      double profit = futureValue - initialAmount;

      // Perhitungan menabung biasa
      double dailySaveWithoutGrowth = targetAmount / 365;
      double daysToReachTargetWithoutGrowth = targetAmount / dailySaveWithoutGrowth;

      // Perhitungan berapa hari yang dihemat
      double daysToReachTargetWithGrowth = log(targetAmount / initialAmount) / log(1 + (_growthRate / 100));
      _daysSaved = daysToReachTargetWithoutGrowth - daysToReachTargetWithGrowth;

      // Menangani jika hari yang dihemat negatif atau tak terhingga
      if (_daysSaved < 0 || _daysSaved.isNaN || _daysSaved.isInfinite) {
        _daysSaved = 0.0;
      }

      setState(() {
        _resultAmount = futureValue;
        _profit = profit;
      });
    } else {
      setState(() {
        _resultAmount = 0.0;
        _profit = 0.0;
        _daysSaved = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Simulasi Investasi',
          style: GoogleFonts.baloo2(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF624E88),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan jumlah uang yang ingin diinvestasikan selama 1 tahun:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Jumlah Investasi (Rp)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                "Masukkan target impian yang ingin dicapai (Rp):",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: "Target Impian (Rp)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(
                "Tingkat Pertumbuhan Per Tahun (%)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _growthRate,
                min: 0,
                max: 20,
                divisions: 20,
                label: _growthRate.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _growthRate = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Perkiraan Hasil Investasi setelah $_years tahun: Rp ${_resultAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Keuntungan dibanding menabung biasa: Rp ${_profit.toStringAsFixed(0)}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.blueGrey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Menampilkan jumlah hari yang dihemat jika positif
              _daysSaved > 0
                  ? Text(
                "Jumlah hari yang dihemat: ${_daysSaved.toStringAsFixed(0)} hari",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.blueGrey[700],
                  fontWeight: FontWeight.w600,
                ),
              )
                  : Text(
                "Mungkin lebih baik kamu jika meningkatkan jumlah investasi",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateBoost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF624E88),
                ),
                child: const Text(
                  "Hitung Simulasi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
