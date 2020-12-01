import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Since it is tied so heavily with visualization, this class is heavily based
// on a similar class from the Boggle project from Project 2
class Square extends CustomPainter{

  String number;
  Color color;
  bool selected;

  Square(int number){
    if(number == 0){
      this.number = '';
    } else {
      this.number = number.toString();
    }
    color = Colors.white;
  }

  void changeNumber(int number){
    this.number = number.toString();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint() ..color = this.color;
    final ts = ui.TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final pBuild = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center, textDirection: TextDirection.ltr)) .. pushStyle(ts) ..addText(number);
    final p = pBuild.build();
    final constraints = ui.ParagraphConstraints(width: size.width);
    p.layout(constraints);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    canvas.drawParagraph(p, Offset(0, (size.height - 30) / 2 ));

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }

}