import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeSelector extends StatelessWidget{
  final DateTime selesctedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime, TimeOfDay) onDateTimeChanged;

  const DateTimeSelector({
    super.key,
    required this.selesctedDate,
    required this.selectedTime,
    required this.onDateTimeChanged,
  });

  Future<void> _selectedDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(context: context,
        initialDate: selesctedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null && picked != selesctedDate) {
      onDateTimeChanged(picked, selectedTime);
    }
  }

  Future<void> _selectedTime(BuildContext context) async{
    final TimeOfDay? picked = await showTimePicker(context: context,
      initialTime: selectedTime,);

    if (picked != null && picked != selesctedDate) {
      onDateTimeChanged(selesctedDate, picked);
    }
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () => _selectedDate(context),
              icon: const Icon(Icons.calendar_today, color: Colors.blue),
              label: Text(
                'Date: ${selesctedDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () => _selectedTime(context),
              icon: const Icon(Icons.access_time, color: Colors.blue),
              label: Text(
                'Time: ${selectedTime.format(context)}',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
