import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pypo/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pypo/widgets/date_time_selector.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();
  DateTime selectedDate = DateTime.now(); // Always set to today's date
  TimeOfDay selectedTime = TimeOfDay.now();

  // Method to schedule notification
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
          backgroundColor: Colors.pink,
        ),
      );
    }

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  // Update only the time, but keep the date fixed to today
  void _updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = DateTime.now(); // Keep the date fixed to today
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        title: Text(
          'Reminder Harian',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Waktu Notifikasi",
                      style: GoogleFonts.baloo2(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DateTimeSelector(
                      selesctedDate: selectedDate,
                      selectedTime: selectedTime,
                      onDateTimeChanged: _updateDateTime,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _scheduleNotification,
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text("Jadwalkan Notifikasi"),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}