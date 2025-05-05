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
  final int _years = 1;

  void _calculateBoost() {
    double initialAmount = double.tryParse(_amountController.text) ?? 0;
    double targetAmount = double.tryParse(_targetController.text) ?? 0;

    if (initialAmount > 0 && targetAmount > 0) {
      double futureValue = initialAmount * pow(1 + (_growthRate / 100), _years);
      setState(() {
        _resultAmount = futureValue;
      });
    } else {
      setState(() {
        _resultAmount = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF624E88),
        title: Text(
          "Simulasi Investasi",
          style: GoogleFonts.baloo2(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // menutup keyboard saat tap luar
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan jumlah uang yang ingin diinvestasikan dan target yang ingin dicapai:",
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
              TextField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: "Jumlah Target (Rp)",
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
                "Perkiraan Hasil Investasi setelah $_years tahun:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "Rp ${_resultAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
