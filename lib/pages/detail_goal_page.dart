import 'package:flutter/material.dart';
import '../models/saving_goal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.goal.title,
          style: GoogleFonts.baloo2(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF624E88), // Deep purple for header
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E5F5), Color(0xFFD1C4E9)], // Soft lavender gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target Dana dan Terkumpul
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withValues(alpha: 0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Target: Rp ${widget.goal.targetAmount.toStringAsFixed(0)} 🎯",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF624E88)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Terkumpul: Rp ${widget.goal.savedAmount.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: percent,
                        color: Color(0xFF9C4D97), // Lighter purple tone for progress
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      if (widget.goal.deadline != null) ...[
                        Text(
                          "Deadline: ${DateFormat('yyyy-MM-dd').format(widget.goal.deadline!)}",
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueAccent),
                        ),
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Input dan Button
              if (!isGoalReached) ...[
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Tambah Tabungan (Rp) 💸',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: GoogleFonts.poppins(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _addSaving,
                  icon: const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Tambah Tabungan",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF624E88), // Deep purple for the button
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    textStyle: GoogleFonts.poppins(),
                  ),
                ),
              ] else ...[
                const Text(
                  "🎯 Target tercapai!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],

              // Add some space at the bottom
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
