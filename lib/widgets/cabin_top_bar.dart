import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CabinTopBar extends StatefulWidget {
  const CabinTopBar({
    super.key,
    required this.cabinName,
  });

  final String cabinName;

  @override
  State<CabinTopBar> createState() => _CabinTopBarState();
}

class _CabinTopBarState extends State<CabinTopBar> {
  late final Timer timer;

  void maybeRebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => maybeRebuild(),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF0c5ee6);

    const timeStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: color,
    );

    const cabinNameStyle = TextStyle(
      fontSize: 24,
      color: color,
      fontWeight: FontWeight.w300,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('HH:mm').format(DateTime.now()),
            style: timeStyle,
          ),
          const Padding(padding: EdgeInsets.only(left: 2)),
          Text(
            widget.cabinName,
            style: cabinNameStyle,
          ),
        ],
      ),
    );
  }
}
