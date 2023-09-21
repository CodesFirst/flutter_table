import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatatableHeader {
  final String text;
  final String value;
  final bool sortable;
  final bool editable;
  bool show;
  final TextAlign textAlign;
  final int flex;
  final Widget Function(dynamic value)? headerBuilder;
  final Widget Function(dynamic value, Map<String?, dynamic> row)?
      sourceBuilder;
  final DataTableFormat format;
  final List<String> items;
  final List<TextInputFormatter>? textInputFormatter;

  DatatableHeader({
    required this.text,
    required this.value,
    this.textAlign = TextAlign.center,
    this.sortable = false,
    this.show = true,
    this.editable = false,
    this.flex = 1,
    this.format = DataTableFormat.normal,
    this.headerBuilder,
    this.sourceBuilder,
    this.items = const [],
    this.textInputFormatter,
  });

  factory DatatableHeader.fromMap(Map<String, dynamic> map) => DatatableHeader(
        text: map['text'],
        value: map['value'],
        sortable: map['sortable'],
        show: map['show'],
        textAlign: map['textAlign'],
        flex: map['flex'],
        headerBuilder: map['headerBuilder'],
        sourceBuilder: map['sourceBuilder'],
        format: map['format'],
        items: map['items'] ?? [],
      );
  Map<String, dynamic> toMap() => {
        "text": text,
        "value": value,
        "sortable": sortable,
        "show": show,
        "textAlign": textAlign,
        "flex": flex,
        "headerBuilder": headerBuilder,
        "sourceBuilder": sourceBuilder,
        "format": format,
        "items": items,
        "textInputFormatter": textInputFormatter,
      };
}

enum DataTableFormat {
  normal,
  date,
  time,
  dateTime,
  number,
  list,
}
