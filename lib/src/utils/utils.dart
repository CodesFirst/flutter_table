// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xtable/xtable.dart';

class UtilTable {
  static void selectDate({
    required BuildContext context,
    required Map<String, dynamic> data,
    required DatatableHeader header,
    required Duration timeToSubtract,
    Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged,
    TextEditingController? controller,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now().subtract(timeToSubtract),
      lastDate: DateTime.now().add(const Duration(hours: 43800)),
    );

    if (picked == null) return;
    final newValue = DateFormat('dd-MM-yyyy').format(picked);
    controller?.text = newValue;
    data[header.value] = newValue;
    onChanged?.call(data, header);
  }

  static void selectTime({
    required BuildContext context,
    required Map<String, dynamic> data,
    required DatatableHeader header,
    Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged,
    TextEditingController? controller,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;
    final newValue = formatTimeOfDay(picked);
    controller?.text = newValue;

    controller?.text = newValue;
    data[header.value] = newValue;
    onChanged?.call(data, header);
  }

  static void showDateTimePicker({
    required BuildContext context,
    required Map<String, dynamic> data,
    required DatatableHeader header,
    required Duration timeToSubtract,
    Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged,
    TextEditingController? controller,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime.now().subtract(timeToSubtract),
      lastDate: DateTime.now().add(const Duration(hours: 43800)),
    );

    if (selectedDate == null || !context.mounted) return;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    String newValue = DateFormat('dd-MM-yyyy').format(selectedDate);
    if (selectedTime != null) {
      final dateWithTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      newValue = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateWithTime);
    }

    controller?.text = newValue;
    data[header.value] = newValue;
    onChanged?.call(data, header);
  }

  /// `formatTimeOfDay`
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
