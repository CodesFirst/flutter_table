import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilTable {
  static void selectDate(
    BuildContext context,
    TextEditingController? controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(hours: 43800)),
    );

    if (picked == null) return;
    controller?.text = DateFormat('dd-MM-yyyy').format(picked);
  }

  static void selectTime(
    BuildContext context,
    TextEditingController? controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;
    final formatTime = formatTimeOfDay(picked);
    controller?.text = formatTime;
  }

  /// `formatTimeOfDay`
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
