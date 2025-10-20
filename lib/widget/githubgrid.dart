import 'package:flutter/material.dart';
import 'dart:math';

/// - [weeks]: number of week-columns (e.g. 52)
/// - [values]: flat list of length weeks * 7, row-major by week then day (0..6)
/// - [estimatedVisibleColumns]: approximate number of columns to fit on screen
class ContributionGrid extends StatefulWidget {
  final int weeks;
  final List<int> values;
  final int estimatedVisibleColumns;
  final double columnSpacing;
  final double rowSpacing;

  const ContributionGrid({
    Key? key,
    required this.weeks,
    required this.values,
    this.estimatedVisibleColumns = 29,
    this.columnSpacing = 6.0,
    this.rowSpacing = 6.0,
  }) : super(key: key);

  @override
  State<ContributionGrid> createState() => _ContributionGridState();
}

class _ContributionGridState extends State<ContributionGrid> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.weeks, (weekIndex) {
          final baseIndex = weekIndex * 7;
          return Padding(
            padding: EdgeInsets.only(right: widget.columnSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(7, (dayIndex) {
                return Padding(
                  padding: EdgeInsets.only(bottom: widget.rowSpacing),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
