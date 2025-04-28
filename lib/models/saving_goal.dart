import 'package:hive/hive.dart';

part 'saving_goal.g.dart';

@HiveType(typeId: 0)
class SavingGoal extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double targetAmount;

  @HiveField(2)
  double savedAmount;

  @HiveField(3)
  DateTime? deadline;

  @HiveField(4)
  String emoji;

  @HiveField(5)
  String colorHex;

  @HiveField(6)
  String? imagePath; // Menambahkan imagePath untuk gambar

  @HiveField(7)
  String? frequency; // Menambahkan frequency untuk frekuensi nabung

  @HiveField(8)
  int dailySaving; // Menambahkan dailySaving untuk estimasi per hari

  @HiveField(9)
  int monthlySaving; // Menambahkan monthlySaving untuk estimasi per bulan

  @HiveField(10)
  int yearlySaving; // Menambahkan yearlySaving untuk estimasi per tahun

  SavingGoal({
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0,
    this.deadline,
    this.emoji = '💰',
    this.colorHex = '#42A5F5',
    this.imagePath,
    this.frequency,
    this.dailySaving = 0,
    this.monthlySaving = 0,
    this.yearlySaving = 0,
  });
}
