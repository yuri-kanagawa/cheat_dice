import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zflutter/zflutter.dart';

import 'mobad.dart';

class Dices3 extends StatefulWidget {
  _Dices3State createState() => _Dices3State();
}

class _Dices3State extends State<Dices3> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  SpringSimulation simulation;
  int num = 1;
  int num2 = 1;
  int num3 = 1;
  ZVector rotation = ZVector.zero;
  double zRotation = 0;
  int press = 1;
  int count;
  int dice_number = 1;
  int dice_number2 = 1;
  int dice_number3 = 1;
  int dice_sum = 2;
  int dice_sum2 = 2;
  int sum_check;

  @override
  void initState() {
    super.initState();

    simulation = SpringSimulation(
      SpringDescription(
        mass: 1,
        stiffness: 20,
        damping: 2,
      ),
      1, // starting point
      0, // ending point
      1, // velocity
    );

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..addListener(() {
        //rotation = rotation + ZVector.all(0.1);
        setState(() {});
      });
  }

  void random() {
    zRotation = Random().nextDouble() * tau;
    num = Random().nextInt(5) + 1;
    num2 = 6 - Random().nextInt(5);
    num3 = 6 - Random().nextInt(5);
  }

  roolcount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    count = prefs.getInt('counter');
  }

  Calculator(int sum) async {
    List<List<int>> value_pattern = [];

    for (int i = 1; i <= 6; i++) {
      for (int j = 1; j <= 6; j++) {
        for (int k = 1; k <= 6; k++) {
          if (i + j + k == sum) {
            value_pattern.add(
              [i, j, k],
            );
          }
        }
      }
    }
    var no = value_pattern.length - 1;
    var pattern = Random().nextInt(no);
    dice_number = value_pattern[pattern][0];
    dice_number2 = value_pattern[pattern][1];
    dice_number3 = value_pattern[pattern][2];
  }

  @override
  Widget build(BuildContext context) {
    //画面サイズ取得
    final Size size = MediaQuery.of(context).size;
    var maxHeight = size.height;
    var maxWidth = size.width;
    var maxWidth_1 = maxWidth / 4 * 1;
    var maxWidth_2 = maxWidth / 4 * 2;
    var maxWidth_3 = maxWidth / 4 * 3;

    final curvedValue = CurvedAnimation(
      curve: Curves.ease,
      parent: animationController,
    );
    final firstHalf = CurvedAnimation(
      curve: Interval(0, 1),
      parent: animationController,
    );
    final secondHalf = CurvedAnimation(
      curve: Interval(0, 0.3),
      parent: animationController,
    );

    final zoom = (simulation.x(animationController.value)).abs() / 2 + 0.5;

    return GestureDetector(
      onTapDown: (details) async {
        press = 0;
        Offset tap_point = details.globalPosition;
        var tap_width = tap_point.dx;
        var tap_height = tap_point.dy;

        if (animationController.isAnimating) {
          animationController.reset(); //アニメーション中断(振り直し)
          Adcount.counter();
        } else {
          roolcount(); //回数取得
          if (count == 1) {
            //偶数回
            print("偶数");
            print(tap_width);
            if (tap_height < 50) {
              //上段
              print("上段");
              press = 1;
              if (maxWidth_1 > tap_width) {
                print("2*2*2");
                dice_number = 2;
                dice_number2 = 2;
                dice_number3 = 2;
              } else if (maxWidth_2 > tap_width) {
                print("1*1*1");
                dice_number = 1;
                dice_number2 = 1;
                dice_number3 = 1;
              } else if (maxWidth_3 > tap_width) {
                //3~6
                print("3~6");
                var value_range = [3, 4, 5, 6];
                int lottery = Random().nextInt(4);
                Calculator(value_range[lottery]);
              } else if (tap_width >= maxWidth_3) {
                print("7~9");
                var value_range = [7, 8, 9];
                int lottery = Random().nextInt(3);
                Calculator(value_range[lottery]);
              }
            } else if (tap_height < 100 && tap_height >= 50) {
              //上中段
              press = 1;
              if (maxWidth_1 > tap_width) {
                print("4*4*4");
                dice_number = 4;
                dice_number2 = 4;
                dice_number3 = 4;
              } else if (maxWidth_2 > tap_width) {
                print("3*3*3");
                dice_number = 3;
                dice_number2 = 3;
                dice_number3 = 3;
              } else if (maxWidth_3 > tap_width) {
                print("4*5*6");
                var value_range = [4, 5, 6];
                int lottery = Random().nextInt(3);
                dice_number = value_range[lottery];
                value_range.remove(dice_number); //１個めのダイスの値削除
                lottery = Random().nextInt(2);
                dice_number2 = value_range[lottery];
                value_range.remove(dice_number2); //2個めのダイスの値削除
                lottery = Random().nextInt(1);
                dice_number3 = value_range[lottery];
              } else if (tap_width >= maxWidth_3) {
                print("10~13");
                var value_range = [10, 11, 12, 13];
                int lottery = Random().nextInt(4);
                Calculator(value_range[lottery]);
              }
            } else if (tap_height < 150) {
              //上下段
              press = 1;
              if (maxWidth_1 > tap_width) {
                print("6*6*6");
                dice_number = 6;
                dice_number2 = 6;
                dice_number3 = 6;
              } else if (maxWidth_2 > tap_width) {
                print("5*5*5");
                dice_number = 5;
                dice_number2 = 5;
                dice_number3 = 5;
              } else if (maxWidth_2 <= tap_width) {
                print("10~11");
                var value_range = [10, 11];
                int lottery = Random().nextInt(2);
                Calculator(value_range[lottery]);
              }
            }
          } else {
            //奇数回数
            if (maxHeight - 150 < tap_height && tap_height <= maxHeight - 100) {
              //上段
              press = 1;
              print("奇数");
              if (maxWidth_1 > tap_width) {
                print("2*2*2");
                dice_number = 2;
                dice_number2 = 2;
                dice_number3 = 2;
              } else if (maxWidth_2 > tap_width) {
                print("1*1*1");
                dice_number = 1;
                dice_number2 = 1;
                dice_number3 = 1;
              } else {
                //3~6
                print("3~6");
                var value_range = [3, 4, 5, 6];
                int lottery = Random().nextInt(4);
                Calculator(value_range[lottery]);
              }
            }
            if (maxHeight - 100 < tap_height && tap_height < maxHeight - 50) {
              //下中断
              press = 1;
              if (maxWidth_1 > tap_width) {
                print("4*4*4");
                dice_number = 4;
                dice_number2 = 4;
                dice_number3 = 4;
              } else if (maxWidth_2 > tap_width) {
                print("3*3*3");
                dice_number = 3;
                dice_number2 = 3;
                dice_number3 = 3;
              } else if (maxWidth_2 <= tap_width) {
                print("7~9");
                var value_range = [7, 8, 9];
                int lottery = Random().nextInt(3);
                Calculator(value_range[lottery]);
              }
            }
            if (maxHeight - 50 < tap_height) {
              //下下断
              press = 1;
              if (maxWidth_1 > tap_width) {
                print("6*6*6");
                dice_number = 6;
                dice_number2 = 6;
                dice_number3 = 6;
              } else if (maxWidth_2 > tap_width) {
                print("5*5*5");
                dice_number = 5;
                dice_number2 = 5;
                dice_number3 = 5;
              } else if (maxWidth_2 <= tap_width) {
                print("10~11");
                var value_range = [10, 11];
                int lottery = Random().nextInt(2);
                Calculator(value_range[lottery]);
              }
            }
          }
        }
        animationController.forward(from: 0);
        Adcount.counter();
        random();
      },
      child: Container(
        color: Colors.transparent,
        child: ZIllustration(
          zoom: 1,
          children: [
            ZPositioned(
              translate: ZVector(-80 * zoom, 50, 0),
              child: ZGroup(
                children: [
                  ZPositioned(
                    scale: ZVector.all(zoom),
                    rotate: press == 0
                        ? getRotation(num3).multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            )
                        : getRotation(dice_number3)
                                .multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            ),
                    child: ZPositioned(
                      rotate: ZVector.only(
                        z: -zRotation * 1.9 * (animationController.value),
                      ),
                      child: Dice(
                        zoom: zoom,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ZPositioned(
              translate: ZVector(80 * zoom, 50, 0),
              child: ZGroup(
                children: [
                  ZPositioned(
                    scale: ZVector.all(zoom),
                    rotate: press == 0
                        ? getRotation(num2).multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            )
                        : getRotation(dice_number2)
                                .multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            ),
                    child: ZPositioned(
                      rotate: ZVector.only(
                        z: -zRotation * 2.1 * (animationController.value),
                      ),
                      child: Dice(zoom: zoom),
                    ),
                  ),
                ],
              ),
            ),
            ZPositioned(
              translate: ZVector(0, -90, 0),
              child: ZGroup(
                children: [
                  ZPositioned(
                    scale: ZVector.all(zoom),
                    rotate: press == 0
                        ? getRotation(num).multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            )
                        : getRotation(dice_number)
                                .multiplyScalar(curvedValue.value) -
                            ZVector.all(
                              (tau / 2) * (firstHalf.value),
                            ) -
                            ZVector.all(
                              (tau / 2) * (secondHalf.value),
                            ),
                    child: ZPositioned(
                      rotate: ZVector.only(
                        z: -zRotation * 2.1 * (animationController.value),
                      ),
                      child: Dice(zoom: zoom),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

ZVector getRotation(int num) {
  switch (num) {
    case 1:
      return ZVector.zero;
    case 2:
      return ZVector.only(x: tau / 4);
    case 3:
      return ZVector.only(y: tau / 4);
    case 4:
      return ZVector.only(y: 3 * tau / 4);
    case 5:
      return ZVector.only(x: 3 * tau / 4);
    case 6:
      return ZVector.only(y: tau / 2);
  }
  throw ('num $num is not in the dice');
}

class Face extends StatelessWidget {
  final double zoom;
  final Color color;

  const Face({Key key, this.zoom = 1, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZRect(
      stroke: 50 * zoom,
      width: 50,
      height: 50,
      color: color,
    );
  }
}

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZCircle(
      diameter: 15,
      stroke: 0,
      fill: true,
      color: Colors.black,
    );
  }
}

class GroupTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.update,
      children: [
        ZPositioned(
          translate: ZVector.only(y: -20),
          child: Dot(),
        ),
        ZPositioned(
          translate: ZVector.only(y: 20),
          child: Dot(),
        ),
      ],
    );
  }
}

class GroupFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ZGroup(
      sortMode: SortMode.update,
      children: [
        ZPositioned(
          translate: ZVector.only(x: 20, y: 0),
          child: GroupTwo(),
        ),
        ZPositioned(
          translate: ZVector.only(x: -20, y: 0),
          child: GroupTwo(),
        ),
      ],
    );
  }
}

class Dice extends StatelessWidget {
  final Color color;
  final double zoom;

  const Dice({Key key, this.zoom = 1, this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZGroup(
      children: [
        ZGroup(
          sortMode: SortMode.update,
          children: [
            ZPositioned(
              translate: ZVector.only(z: -25),
              child: Face(zoom: zoom, color: color),
            ),
            ZPositioned(
              translate: ZVector.only(z: 25),
              child: Face(zoom: zoom, color: color),
            ),
            ZPositioned(
              translate: ZVector.only(y: 25),
              rotate: ZVector.only(x: tau / 4),
              child: Face(
                zoom: zoom,
                color: color,
              ),
            ),
            ZPositioned(
              translate: ZVector.only(y: -25),
              rotate: ZVector.only(x: tau / 4),
              child: Face(zoom: zoom, color: color),
            ),
          ],
        ),
        //one
        ZPositioned(
          translate: ZVector.only(z: 50),
          child: Dot(),
        ),
        //two
        ZPositioned(
          rotate: ZVector.only(x: tau / 4),
          translate: ZVector.only(y: 50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(
                translate: ZVector.only(y: -20),
                child: Dot(),
              ),
              ZPositioned(
                translate: ZVector.only(y: 20),
                child: Dot(),
              ),
            ],
          ),
        ),
        //three
        ZPositioned(
          rotate: ZVector.only(y: tau / 4),
          translate: ZVector.only(x: 50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              Dot(),
              ZPositioned(
                translate: ZVector.only(x: 20, y: -20),
                child: Dot(),
              ),
              ZPositioned(
                translate: ZVector.only(x: -20, y: 20),
                child: Dot(),
              ),
            ],
          ),
        ),
        //four
        ZPositioned(
          rotate: ZVector.only(y: tau / 4),
          translate: ZVector.only(x: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(
                translate: ZVector.only(x: 20, y: 0),
                child: GroupTwo(),
              ),
              ZPositioned(
                translate: ZVector.only(x: -20, y: 0),
                child: GroupTwo(),
              ),
            ],
          ),
        ),

        //five
        ZPositioned(
          rotate: ZVector.only(x: tau / 4),
          translate: ZVector.only(y: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              Dot(),
              ZPositioned(
                child: GroupFour(),
              ),
            ],
          ),
        ),

        //six
        ZPositioned(
          translate: ZVector.only(z: -50),
          child: ZGroup(
            sortMode: SortMode.update,
            children: [
              ZPositioned(
                rotate: ZVector.only(z: tau / 4),
                child: GroupTwo(),
              ),
              ZPositioned(
                child: GroupFour(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
