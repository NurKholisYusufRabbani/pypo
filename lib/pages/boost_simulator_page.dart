import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:pypo/models/saving_goal.dart';

class BoostSimulatorPage extends StatefulWidget {
  final SavingGoal goal;

  const BoostSimulatorPage({super.key, required this.goal});

  @override
  State<BoostSimulatorPage> createState() => _BoostSimulatorPageState();
}

class _BoostSimulatorPageState extends State<BoostSimulatorPage> {
  final _boostController = TextEditingController();
  final _returnController = TextEditingController();
  final _yearsController = TextEditingController();

  double? result;

  void _calculateBoost() {
    final nominal = double.tryParse(_boostController.text);
    final returnRate = double.tryParse(_returnController.text);
    final years = double.tryParse(_yearsController.text);

    if (nominal != null && returnRate != null && years != null) {
      final futureValue = nominal * pow((1 + returnRate / 100), years);
      setState(() {
        result = futureValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Boost: ${widget.goal.title}',
          style: GoogleFonts.baloo2(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF624E88),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            // Menambahkan efek tombol kembali yang lucu
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('👋 Kembali ke Goal!')),
            );
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎯 Tujuan: ${widget.goal.title}',
                style: GoogleFonts.baloo2(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                'Terkumpul: Rp ${widget.goal.savedAmount.toStringAsFixed(0)} / Rp ${widget.goal.targetAmount.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.black54),
              ),
              const Divider(height: 24),
              TextField(
                controller: _boostController,
                decoration: InputDecoration(
                  labelText: 'Nominal Investasi (Rp) 💰',
                  border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.baloo2(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.baloo2(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _returnController,
                decoration: InputDecoration(
                  labelText: 'Return per Tahun (%) 📈',
                  border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.baloo2(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.baloo2(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _yearsController,
                decoration: InputDecoration(
                  labelText: 'Durasi (Tahun) ⏳',
                  border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.baloo2(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.baloo2(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _calculateBoost,
                icon: const Icon(Icons.flash_on, color: Colors.yellow),
                label: Text(
                  'Hitung 🚀',
                  style: GoogleFonts.baloo2(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF624E88), // Ubah jadi ungu
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  textStyle: GoogleFonts.baloo2(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              if (result != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hasil Simulasi: 🎉",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rp ${result!.toStringAsFixed(0)} 💸",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text("✨ Lumayan buat percepat impianmu!"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
