import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'dice1.dart';
import 'dice2.dart';
import 'dice3.dart';

// ignore: must_be_immutable
class ScreenList extends StatelessWidget {
  List<Widget>  screen = <Widget>[
    Dices1(),
    Dices2(),
    Dices3(),
  ];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return CarouselSlider.builder(
        options: CarouselOptions(
          height: height,
          enableInfiniteScroll: false,
          viewportFraction: 1.0,
        ),
      itemCount: screen.length,
      itemBuilder: (context, itemIndex, realIndex) {
        return screen[itemIndex];
      }

    );

  }


}
