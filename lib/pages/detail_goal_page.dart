import 'package:flutter/material.dart';
import '../models/saving_goal.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailGoalPage extends StatefulWidget {
  final SavingGoal goal;

  const DetailGoalPage({super.key, required this.goal});

  @override
  State<DetailGoalPage> createState() => _DetailGoalPageState();
}

class _DetailGoalPageState extends State<DetailGoalPage> {
  final _amountController = TextEditingController();

  void _addSaving() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      final remaining = widget.goal.targetAmount - widget.goal.savedAmount;
      final addedAmount = amount > remaining ? remaining : amount;

      setState(() {
        widget.goal.savedAmount += addedAmount;
      });
      await widget.goal.save();
      _amountController.clear();

      if (!mounted) return;
      if (widget.goal.savedAmount >= widget.goal.targetAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 Selamat! Target tabungan tercapai!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.goal.savedAmount / widget.goal.targetAmount).clamp(0.0, 1.0);
    final isGoalReached = widget.goal.savedAmount >= widget.goal.targetAmount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,  // Ikon kembali yang lucu
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
        ),
        title: Text(
          widget.goal.title,
          style: GoogleFonts.baloo2(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF624E88),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Target: Rp ${widget.goal.targetAmount.toStringAsFixed(0)} 🎯",  // Menambahkan emoji di target
              style: GoogleFonts.baloo2(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Terkumpul: Rp ${widget.goal.savedAmount.toStringAsFixed(0)}",
              style: GoogleFonts.baloo2(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: percent),
            const SizedBox(height: 20),
            if (!isGoalReached) ...[
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Tambah Tabungan (Rp) 💸',
                  border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.baloo2(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.baloo2(),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addSaving,
                icon: const Icon(
                  Icons.monetization_on,
                  color: Colors.yellow,
                ),
                label: Text(
                  "Tambah Tabungan",
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF624E88),
                  foregroundColor: Colors.white,
                  textStyle: GoogleFonts.baloo2(),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
              )
            ] else ...[
              const Text(
                "🎯 Target tercapai!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
