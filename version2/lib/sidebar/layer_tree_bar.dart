// Layer Tree Bar: סלייד־בר תחתון לניהול ועץ שכבות
import 'package:flutter/material.dart';

class LayerTreeBar extends StatelessWidget {
  const LayerTreeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.blueGrey[50],
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'סרגל שכבות — כאן יוצגו וינוהלו כל השכבות',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
        ),
      ),
    );
  }
}
