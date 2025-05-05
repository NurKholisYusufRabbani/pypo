import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/saving_goal.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _fillingController = TextEditingController();
  DateTime? _deadline;
  String? _imagePath;
  String? _frequency = 'Harian';
  int _dailySaving = 0;
  int _monthlySaving = 0;
  int _yearlySaving = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _fillingController.dispose();
    super.dispose();
  }

  void _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final savedAmount = double.tryParse(_fillingController.text) ?? 0;

      final goal = SavingGoal(
        title: _titleController.text,
        targetAmount: double.parse(_targetController.text),
        savedAmount: savedAmount,
        deadline: _deadline,
        imagePath: _imagePath,
        frequency: _frequency,
        dailySaving: _dailySaving,
        monthlySaving: _monthlySaving,
        yearlySaving: _yearlySaving,
      );

      final box = Hive.box<SavingGoal>('goals');
      await box.add(goal);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _calculateEstimation() {
    final target = double.tryParse(_targetController.text);
    final filling = double.tryParse(_fillingController.text);

    if (target != null) {
      final remaining = (target - (filling ?? 0)).clamp(0, target);

      // Hitung sisa waktu berdasarkan deadline
      final remainingDays = _deadline != null ? _deadline!.difference(DateTime.now()).inDays : 0;

      if (remainingDays <= 0) {
        // Jika deadline sudah lewat atau tidak valid, set semua saran nabung menjadi "-"
        setState(() {
          _dailySaving = 0;
          _monthlySaving = 0;
          _yearlySaving = 0;
        });
        return;
      }

      // Perhitungan saran nabung sesuai frekuensi
      if (_frequency == 'Harian' && remainingDays > 0) {
        _dailySaving = (remaining / remainingDays).toInt();
        _monthlySaving = _dailySaving * 30;
        _yearlySaving = _dailySaving * 365;
      } else if (_frequency == 'Bulanan' && remainingDays > 30) {
        _monthlySaving = (remaining / (remainingDays / 30)).toInt();
        _dailySaving = (_monthlySaving / 30).toInt();
        _yearlySaving = _monthlySaving * 12;
      } else if (_frequency == 'Tahunan' && remainingDays > 365) {
        _yearlySaving = remaining.toInt();
        _monthlySaving = _yearlySaving ~/ 12;
        _dailySaving = _yearlySaving ~/ 365;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Impian',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Impian'),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Dana (Rp)'),
                validator: (val) {
                  final value = double.tryParse(val ?? '');
                  if (value == null || value <= 0) return 'Masukkan angka yang valid';
                  return null;
                },
                onChanged: (_) => _calculateEstimation(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fillingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tabungan Saat Ini (Rp)'),
                validator: (val) {
                  final filling = double.tryParse(val ?? '');
                  final target = double.tryParse(_targetController.text);
                  if (filling == null || filling < 0) return 'Masukkan angka yang valid';
                  if (target != null && filling > target) return 'Tidak boleh lebih besar dari target';
                  return null;
                },
                onChanged: (_) => _calculateEstimation(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: _imagePath == null
                    ? const Icon(Icons.add_a_photo, size: 100, color: Colors.grey)
                    : Stack(
                  children: [
                    Image.file(File(_imagePath!)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _imagePath = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (!mounted) return;
                  if (picked != null) {
                    setState(() {
                      _deadline = picked;
                    });
                  }
                },
                icon: const Icon(Icons.date_range),
                label: Text(
                  _deadline == null
                      ? "Pilih Deadline"
                      : "Deadline: ${DateFormat('yyyy-MM-dd').format(_deadline!)}",
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequency,
                items: const [
                  DropdownMenuItem(value: 'Harian', child: Text('Harian')),
                  DropdownMenuItem(value: 'Bulanan', child: Text('Bulanan')),
                  DropdownMenuItem(value: 'Tahunan', child: Text('Tahunan')),
                ],
                onChanged: (val) {
                  setState(() {
                    _frequency = val;
                    _calculateEstimation();
                  });
                },
                decoration: const InputDecoration(labelText: 'Frekuensi Nabung'),
              ),
              const SizedBox(height: 16),
              Text('Saran Nabung:', style: const TextStyle(fontWeight: FontWeight.bold)),
              if (_frequency == 'Harian') ...[
                // Hanya tampilkan jika waktu cukup
                Text('Harian: Rp $_dailySaving'),
              ] else if (_frequency == 'Bulanan') ...[
                if (_deadline != null && _deadline!.difference(DateTime.now()).inDays < 30)
                  Text('Bulanan: -') // Menampilkan tanda "-" jika deadline terlalu dekat
                else
                  Text('Bulanan: Rp $_monthlySaving'),
              ] else if (_frequency == 'Tahunan') ...[
                if (_deadline != null && _deadline!.difference(DateTime.now()).inDays < 365)
                  Text('Tahunan: -') // Menampilkan tanda "-" jika deadline terlalu dekat
                else
                  Text('Tahunan: Rp $_yearlySaving'),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Simpan Impian 💡'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
