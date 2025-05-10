import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pypo/models/saving_goal.dart';
import 'package:pypo/services/notification_service.dart';
import 'package:pypo/widgets/date_time_selector.dart';
import 'add_goal_page.dart';
import 'detail_goal_page.dart';
import 'notification_page.dart';
import 'boost_simulator_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationService = NotificationService();
  DateTime selectedDate = DateTime.now(); // Always set to today's date
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _scheduleNotification() async {
    final DateTime scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a future date and time"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    await _notificationService.scheduleNotification(scheduledDateTime);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Notification scheduled for ${scheduledDateTime.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Update only the time, but keep the date fixed to today
  void _updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = DateTime.now(); // Keep the date fixed to today
      selectedTime = time;
    });
  }

  late final Box<SavingGoal> _goalBox;

  @override
  void initState() {
    super.initState();
    _goalBox = Hive.box<SavingGoal>('goals');
    _checkShowEducation();
  }

  void _checkShowEducation() async {
    final appBox = Hive.box('app');
    final hasShownEdu = appBox.get('shownEducation') ?? false;
    final isAllZero = _goalBox.values.every((g) => g.savedAmount == 0);

    if (!hasShownEdu && isAllZero) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Yuk Belajar Investasi 💡"),
          content: const Text(
            "Tahukah kamu? Dengan investasi, impianmu bisa tercapai lebih cepat! "
                "Coba fitur Boost untuk simulasikan hasil investasi dan percepat tujuanmu 💸🔥",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                appBox.put('shownEducation', true);
              },
              child: const Text("Oke, Mengerti!"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF624E88),
        title: Text(
          "PyPo",
          style: GoogleFonts.baloo2(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Tentang PyPo"),
                  content: const Text(
                    "Aplikasi ini membantu kamu untuk mengatur impian dan menabung untuk mencapainya.\n\n"
                        "Kamu bisa menggunakan fitur Boost untuk mempercepat pencapaian tujuanmu melalui simulasi investasi.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<Box<SavingGoal>>(
          valueListenable: _goalBox.listenable(),
          builder: (context, goals, _) {
            if (goals.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada impian. Ayo mulai menabung untuk impianmu!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals.getAt(index);
                if (goal == null) return const SizedBox.shrink();

                final progress =
                (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

                return Dismissible(
                  key: Key(goal.key.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Hapus Impian"),
                        content: Text("Yakin ingin menghapus '${goal.title}'?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    await goal.delete();
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: goal.imagePath != null && File(goal.imagePath!).existsSync()
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(goal.imagePath!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.image, size: 60),
                      title: Text(
                        goal.title,
                        style: GoogleFonts.baloo2(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terkumpul: Rp ${goal.savedAmount.toStringAsFixed(0)} / Rp ${goal.targetAmount.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailGoalPage(goal: goal)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tooltip(
            message: "Simulasi investasi (Boost)",
            child: FloatingActionButton(
              heroTag: "boostBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoostSimulatorPage()),
                );
              },
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.trending_up),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: "Tambah Impian Baru",
            child: FloatingActionButton(
              heroTag: "addGoalBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddGoalPage()),
                );
              },
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: "Atur reminder",
            child: FloatingActionButton(
              heroTag: "notifBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.notifications),
            ),
          ),
        ],
      ),
    );
  }
}
