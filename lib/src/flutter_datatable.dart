import 'package:adaptivex/adaptivex.dart';
import 'package:flutter/material.dart';
import 'package:xtable/src/utils/utils.dart';

import 'models/datatable_header.dart';

class XDataTable extends StatefulWidget {
  final bool showSelect;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>>? source;
  final List<Map<String, dynamic>>? selecteds;
  final Widget? title;
  final List<Widget>? actions;
  final List<Widget>? footers;
  final Function(bool? value)? onSelectAll;
  final Function(bool? value, Map<String, dynamic> data)? onSelect;
  final Function(Map<String, dynamic> value)? onTabRow;
  final Function(dynamic value)? onSort;
  final String? sortColumn;
  final bool? sortAscending;
  final bool isLoading;
  final bool autoHeight;
  final bool hideUnderline;
  final bool commonMobileView;
  final bool isExpandRows;
  final String? sortText;
  final bool showSort;
  final List<bool>? expanded;
  final Widget Function(Map<String, dynamic> value)? dropContainer;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onChangedRow;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onSubmittedRow;

  /// `reponseScreenSizes`
  ///
  /// the ScreenSize that will responsive as list view
  final List<ScreenSize> reponseScreenSizes;

  /// `headerDecoration`
  ///
  /// allow to decorate the header row
  final BoxDecoration? headerDecoration;

  /// `rowDecoration`
  ///
  /// allow to decorate the data row
  final BoxDecoration? rowDecoration;

  /// `selectedDecoration`
  ///
  /// allow to decorate the selected data row
  final BoxDecoration? selectedDecoration;

  /// `selectedTextStyle`
  ///
  /// allow to styling the header row
  final TextStyle? headerTextStyle;

  /// `selectedTextStyle`
  ///
  /// allow to styling the data row
  final TextStyle? rowTextStyle;

  /// `selectedTextStyle`
  ///
  /// allow to styling the selected data row
  final TextStyle? selectedTextStyle;

  ///`timeToSubtract`
  ///
  /// is the time that is restored to the start date in the date inputs
  final Duration timeToSubtract;

  const XDataTable({
    Key? key,
    this.showSelect = false,
    this.onSelectAll,
    this.onSelect,
    this.onTabRow,
    this.onSort,
    this.sortText = 'SORT BY',
    this.showSort = false,
    this.headers = const [],
    this.source,
    this.selecteds,
    this.title,
    this.actions,
    this.footers,
    this.sortColumn,
    this.sortAscending,
    this.isLoading = false,
    this.autoHeight = true,
    this.hideUnderline = true,
    this.commonMobileView = false,
    this.isExpandRows = true,
    this.expanded,
    this.dropContainer,
    this.onChangedRow,
    this.onSubmittedRow,
    this.reponseScreenSizes = const [
      ScreenSize.xs,
      ScreenSize.sm,
      ScreenSize.md
    ],
    this.headerDecoration,
    this.rowDecoration,
    this.selectedDecoration,
    this.headerTextStyle,
    this.rowTextStyle,
    this.selectedTextStyle,
    this.timeToSubtract = const Duration(seconds: 0),
  }) : super(key: key);

  @override
  State<XDataTable> createState() => _XDataTableState();
}

class _XDataTableState extends State<XDataTable> {
  Widget mobileHeader({required showSelect, required showSort}) {
    if (showSelect || showSort) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showSelect)
            Checkbox(
              value: widget.selecteds!.length == widget.source!.length &&
                  widget.source != null &&
                  widget.source!.isNotEmpty,
              onChanged: (value) {
                if (widget.onSelectAll != null) widget.onSelectAll!(value);
              },
            ),
          if (showSort)
            PopupMenuButton(
              tooltip: widget.sortText,
              initialValue: widget.sortColumn,
              itemBuilder: (_) => widget.headers
                  .where((header) =>
                      header.show == true && header.sortable == true)
                  .toList()
                  .map((header) => PopupMenuItem(
                        value: header.value,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              header.text,
                              textAlign: header.textAlign,
                            ),
                            if (widget.sortColumn != null &&
                                widget.sortColumn == header.value)
                              widget.sortAscending!
                                  ? const Icon(Icons.arrow_downward, size: 15)
                                  : const Icon(Icons.arrow_upward, size: 15)
                          ],
                        ),
                      ))
                  .toList(),
              onSelected: (dynamic value) {
                if (widget.onSort != null) widget.onSort!(value);
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Text(widget.sortText ?? "SORT BY"),
              ),
            )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<Widget> mobileList() {
    final decoration = BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)));
    final rowDecoration = widget.rowDecoration ?? decoration;
    final selectedDecoration = widget.selectedDecoration ?? decoration;
    return widget.source!.map((data) {
      return InkWell(
        onTap: () => widget.onTabRow?.call(data),
        child: Container(
          decoration: widget.selecteds!.contains(data)
              ? selectedDecoration
              : rowDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  if (widget.showSelect && widget.selecteds != null)
                    Checkbox(
                        value: widget.selecteds!.contains(data),
                        onChanged: (value) {
                          if (widget.onSelect != null) {
                            widget.onSelect!(value, data);
                          }
                        }),
                ],
              ),
              if (widget.commonMobileView && widget.dropContainer != null)
                widget.dropContainer!(data),
              if (!widget.commonMobileView)
                ...widget.headers
                    .where((header) => header.show == true)
                    .toList()
                    .map(
                      (header) => Container(
                        padding: const EdgeInsets.all(11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            header.headerBuilder != null
                                ? header.headerBuilder!(header.value)
                                : Text(
                                    header.text,
                                    overflow: TextOverflow.clip,
                                    style: widget.selecteds!.contains(data)
                                        ? widget.selectedTextStyle
                                        : widget.rowTextStyle,
                                  ),
                            const Spacer(),
                            header.sourceBuilder != null
                                ? header.sourceBuilder!(
                                    data[header.value], data)
                                : header.editable
                                    ? TextEditableWidget(
                                        data: data,
                                        header: header,
                                        textAlign: TextAlign.end,
                                        onChanged: widget.onChangedRow,
                                        onSubmitted: widget.onSubmittedRow,
                                        hideUnderline: widget.hideUnderline,
                                        timeToSubtract: widget.timeToSubtract,
                                      )
                                    : Expanded(
                                        child: Text(
                                          "${data[header.value]}",
                                          textAlign: header.textAlign,
                                          style:
                                              widget.selecteds!.contains(data)
                                                  ? widget.selectedTextStyle
                                                  : widget.rowTextStyle,
                                        ),
                                      )
                          ],
                        ),
                      ),
                    )
                    .toList()
            ],
          ),
        ),
      );
    }).toList();
  }

  static Alignment headerAlignSwitch(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    final headerDecoration = widget.headerDecoration ??
        BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)));
    return Container(
      decoration: headerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSelect && widget.selecteds != null)
            Checkbox(
                value: widget.selecteds!.length == widget.source!.length &&
                    widget.source != null &&
                    widget.source!.isNotEmpty,
                onChanged: (value) {
                  if (widget.onSelectAll != null) widget.onSelectAll!(value);
                }),
          ...widget.headers
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                    flex: header.flex,
                    child: InkWell(
                      onTap: () {
                        if (widget.onSort != null && header.sortable) {
                          widget.onSort!(header.value);
                        }
                      },
                      child: header.headerBuilder != null
                          ? header.headerBuilder!(header.value)
                          : Container(
                              padding: const EdgeInsets.all(11),
                              alignment: headerAlignSwitch(header.textAlign),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    header.text,
                                    textAlign: header.textAlign,
                                    style: widget.headerTextStyle,
                                  ),
                                  if (widget.sortColumn != null &&
                                      widget.sortColumn == header.value)
                                    widget.sortAscending!
                                        ? const Icon(Icons.arrow_downward,
                                            size: 15)
                                        : const Icon(Icons.arrow_upward,
                                            size: 15)
                                ],
                              ),
                            ),
                    )),
              )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    final decoration = BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)));
    final rowDecoration = widget.rowDecoration ?? decoration;
    final selectedDecoration = widget.selectedDecoration ?? decoration;
    List<Widget> widgets = [];
    for (var index = 0; index < widget.source!.length; index++) {
      final data = widget.source![index];
      widgets.add(Column(
        children: [
          InkWell(
            onTap: () {
              widget.onTabRow?.call(data);
              setState(() {
                widget.expanded![index] = !widget.expanded![index];
              });
            },
            child: Container(
              padding: EdgeInsets.all(widget.showSelect ? 0 : 11),
              decoration: widget.selecteds!.contains(data)
                  ? selectedDecoration
                  : rowDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showSelect && widget.selecteds != null)
                    Row(
                      children: [
                        Checkbox(
                            value: widget.selecteds!.contains(data),
                            onChanged: (value) {
                              if (widget.onSelect != null) {
                                widget.onSelect!(value, data);
                              }
                            }),
                      ],
                    ),
                  ...widget.headers
                      .where((header) => header.show == true)
                      .map(
                        (header) => Expanded(
                          flex: header.flex,
                          child: header.sourceBuilder != null
                              ? header.sourceBuilder!(data[header.value], data)
                              : header.editable
                                  ? TextEditableWidget(
                                      data: data,
                                      header: header,
                                      textAlign: header.textAlign,
                                      onChanged: widget.onChangedRow,
                                      onSubmitted: widget.onSubmittedRow,
                                      hideUnderline: widget.hideUnderline,
                                      timeToSubtract: widget.timeToSubtract,
                                    )
                                  : Text(
                                      "${data[header.value]}",
                                      textAlign: header.textAlign,
                                      style: widget.selecteds!.contains(data)
                                          ? widget.selectedTextStyle
                                          : widget.rowTextStyle,
                                    ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
          if (widget.isExpandRows &&
              widget.expanded![index] &&
              widget.dropContainer != null)
            widget.dropContainer!(data)
        ],
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return widget.reponseScreenSizes.isNotEmpty &&
            widget.reponseScreenSizes.contains(context.screenSize)
        ?

        /// for small screen
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!
                    ],
                  ),
                ),

              if (widget.autoHeight)
                Column(
                  children: [
                      mobileHeader(
                        showSelect: (widget.showSelect && widget.selecteds != null), 
                        showSort: (widget.showSort && widget.onSort!=null)
                        ),
                    if (widget.isLoading) const LinearProgressIndicator(),
                    ...mobileList(),
                  ],
                ),
              if (!widget.autoHeight)
                Expanded(
                  child: ListView(
                    /// itemCount: source.length,
                    children: [
                       mobileHeader(
                        showSelect: (widget.showSelect && widget.selecteds != null), 
                        showSort: (widget.showSort && widget.onSort!=null)
                        ),
                      if (widget.isLoading) const LinearProgressIndicator(),

                      /// mobileList
                      ...mobileList(),
                    ],
                  ),
                ),

              /// footer
              if (widget.footers != null)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [...widget.footers!],
                )
            ],
          )
        /**
          * for large screen
          */
        : Column(
            children: [
              //title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!
                    ],
                  ),
                ),

              /// desktopHeader
              if (widget.headers.isNotEmpty) desktopHeader(),

              if (widget.isLoading) const LinearProgressIndicator(),

              if (widget.autoHeight) Column(children: desktopList()),

              if (!widget.autoHeight)
                // desktopList
                if (widget.source != null && widget.source!.isNotEmpty)
                  Expanded(child: ListView(children: desktopList())),

              //footer
              if (widget.footers != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [...widget.footers!],
                )
            ],
          );
  }
}

/// `TextEditableWidget`
///
/// use to display when user allow any header columns to be editable
class TextEditableWidget extends StatelessWidget {
  /// `data`
  ///
  /// current data as Map
  final Map<String, dynamic> data;

  /// `header`
  ///
  /// current editable text header
  final DatatableHeader header;

  /// `textAlign`
  ///
  /// by default textAlign will be center
  final TextAlign textAlign;

  /// `hideUnderline`
  ///
  /// allow use to decorate hideUnderline false or true
  final bool hideUnderline;

  /// `onChanged`
  ///
  /// trigger the call back update when user make any text change
  final Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged;

  /// `onSubmitted`
  ///
  /// trigger the call back when user press done or enter
  final Function(Map<String, dynamic> vaue, DatatableHeader header)?
      onSubmitted;

  ///`timeToSubtract`
  ///
  /// is the time that is restored to the start date in the date inputs
  final Duration timeToSubtract;

  const TextEditableWidget({
    Key? key,
    required this.data,
    required this.header,
    required this.timeToSubtract,
    this.textAlign = TextAlign.center,
    this.hideUnderline = false,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController.fromValue(
      TextEditingValue(text: "${data[header.value]}"),
    );
    return header.format == DataTableFormat.list
        ? DropdownFieldWidget(
            controller: controller,
            data: data,
            elements: header.items,
            header: header,
            func: onChanged,
          )
        : Container(
            constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: TextField(
              inputFormatters: header.textInputFormatter,
              keyboardType: header.format == DataTableFormat.number
                  ? TextInputType.number
                  : null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: hideUnderline
                    ? InputBorder.none
                    : const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1)),
                alignLabelWithHint: true,
              ),
              textAlign: textAlign,
              controller: controller,
              onChanged: (newValue) {
                data[header.value] = newValue;
                onChanged?.call(data, header);
              },
              readOnly: header.format == DataTableFormat.date ||
                      header.format == DataTableFormat.dateTime ||
                      header.format == DataTableFormat.time
                  ? true
                  : false,
              onTap: header.format == DataTableFormat.date
                  ? () => UtilTable.selectDate(
                      context: context,
                      data: data,
                      header: header,
                      controller: controller,
                      onChanged: onChanged,
                      timeToSubtract: timeToSubtract)
                  : header.format == DataTableFormat.time
                      ? () => UtilTable.selectTime(
                            context: context,
                            data: data,
                            header: header,
                            controller: controller,
                            onChanged: onChanged,
                          )
                      : header.format == DataTableFormat.dateTime
                          ? () => UtilTable.showDateTimePicker(
                                context: context,
                                data: data,
                                header: header,
                                controller: controller,
                                onChanged: onChanged,
                                timeToSubtract: timeToSubtract,
                              )
                          : null,
              onSubmitted: (x) => onSubmitted?.call(data, header),
            ),
          );
  }
}

class DropdownFieldWidget extends StatelessWidget {
  const DropdownFieldWidget({
    Key? key,
    required this.controller,
    required this.elements,
    required this.data,
    required this.header,
    this.func,
  }) : super(key: key);
  final TextEditingController controller;
  final List<String> elements;
  final Map<String, dynamic> data;
  final DatatableHeader header;
  final Function(Map<String, dynamic> vaue, DatatableHeader header)? func;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        hint: Text(controller.text),
        // decoration: const InputDecoration(
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: Colors.blueAccent, width: 0.0),
        //   ),
        //   border: OutlineInputBorder(borderSide: BorderSide(color: ColorTablet.lightBlueColor)),
        // ),
        items: elements.map(
          (val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          },
        ).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.text = value;
            data[header.value] = value;
            func?.call(data, header);
          }
        },
      ),
    );
  }
}
