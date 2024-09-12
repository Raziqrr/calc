/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-09-07 16:02:36
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-09-11 18:22:48
/// @FilePath: lib/home_page.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'dart:collection';

import 'package:calculators/Themes/dark_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CustomTheme currentTheme;

  final darkTheme = CustomTheme(
      screenColor: Color(0xffFFFFFF),
      reflectionColor: Color(0xffCAD4D6),
      textColor: Color(0xff000000),
      buttonColor: Color(0xffD9D9D9),
      backgoundColor: Color(0xff4B5253));

  final lightTheme = CustomTheme(
      screenColor: Color(0xff000000),
      reflectionColor: Color(0xff535D5F),
      textColor: Color(0xffFFFFFF),
      buttonColor: Color(0xff354643),
      backgoundColor: Color(0xffFEFFFF));

  IconData lightIcon = Icons.dark_mode_outlined;
  IconData darkIcon = Icons.dark_mode;

  String currentEntry = "empty";

  Queue numberQueue = Queue<String>();
  Queue expressionQueue = Queue<String>();

  late IconData currentIcon;

  void ClickNumber(String number) {
    if (numberQueue.isEmpty) {
      numberQueue.add(number);
    } else {
      if (numberQueue.length == expressionQueue.length) {
        numberQueue.add(number);
      } else {
        final currentNum = numberQueue.removeLast();
        final newNum = currentNum + number;
        numberQueue.addLast(newNum);
      }
    }
    print(numberQueue);
    setState(() {});
  }

  void ClickExpression(String expression) {
    print(expression);
    if (numberQueue.isNotEmpty) {
      if (expressionQueue.isEmpty) {
        expressionQueue.add(expression);
      } else {
        if (numberQueue.length == expressionQueue.length) {
          expressionQueue.removeLast();
          expressionQueue.addLast(expression);
        } else if (numberQueue.length == 2 && expressionQueue.isNotEmpty) {
          Calculate();
          print("More expression");
        }
      }
    }
    print(expressionQueue);
    setState(() {});
  }

  void AddDecimalNumber(currentNum, toAddNum) {
    final numberString = currentNum.toString();
    final newNumString = numberString + toAddNum.toString();
    numberQueue.addLast(double.parse(newNumString));
  }

  void AddToNumber(currentNum, toAddNum) {
    final newNumber = (currentNum * 10) + toAddNum;
    numberQueue.addLast(newNumber);
    setState(() {});
  }

  void Backspace() {
    if (numberQueue.isNotEmpty) {
      if (numberQueue.length == expressionQueue.length) {
        expressionQueue.removeLast();
      } else {
        final String currentNumber = numberQueue.removeLast();
        final newNumber = currentNumber.substring(0, currentNumber.length - 1);
        numberQueue.addLast(newNumber);
      }
      if (numberQueue.last == "") {
        numberQueue.removeLast();
      }
      print(numberQueue);
      print(1.9 % 1);
    }
    setState(() {});
  }

  void ToDouble() {
    if (numberQueue.isNotEmpty) {
      final String currentNumber = numberQueue.removeLast();
      if (!currentNumber.contains(".")) {
        final newNumber = currentNumber + ".";
        numberQueue.addLast(newNumber);
      } else {
        numberQueue.addLast(currentNumber);
      }
    }
    setState(() {});
  }

  void Inverse() {
    if (numberQueue.isNotEmpty) {
      if (numberQueue.length != expressionQueue.length) {
        final String currentNumber = numberQueue.removeLast();
        if (currentNumber.contains(".")) {
          final newNumber = double.parse(currentNumber);
          final invertedNumber = 0 - newNumber;
          numberQueue.addLast(invertedNumber.toString());
        } else {
          final newNumber = int.parse(currentNumber);
          final invertedNumber = 0 - newNumber;
          print(invertedNumber);
          numberQueue.addLast(invertedNumber.toString());
        }
      }
    }
    print(numberQueue.last);
    setState(() {});
  }

  void AddMinus() {
    if ((numberQueue.isEmpty) ||
        (numberQueue.length == expressionQueue.length)) {
      numberQueue.addLast("-");
    } else if (numberQueue.last != "-") {
      ClickExpression("-");
    }
    setState(() {});
  }

  void Calculate() {
    if (numberQueue.length == 2 && expressionQueue.isNotEmpty) {
      print("calculating");
      final firstNum = double.parse("${(numberQueue.removeFirst())}");
      final secondNum = double.parse("${(numberQueue.removeLast())}");
      final operator = expressionQueue.removeFirst();
      double result = 0;
      switch (operator) {
        case "+":
          result = firstNum + secondNum;
          break;
        case "-":
          result = firstNum - secondNum;
          break;
        case "x":
          result = firstNum * secondNum;
          break;
        case "/":
          if (secondNum == 0) {
            print("Error: Division by zero");
            return;
          }
          result = firstNum / secondNum;
          break;
      }

      if (result % 1 > 0) {
        numberQueue.addLast("$result");
      } else {
        numberQueue.addLast("${result.toInt()}");
      }
    } else {
      print("will not calculate");
    }
    setState(() {});
  }

  void Erase() {
    numberQueue.clear();
    expressionQueue.clear();
    setState(() {});
  }

  void Percentage() {
    if (numberQueue.isNotEmpty) {
      if (numberQueue.length == 2) {
        final currentNumber = numberQueue.removeLast();
        final convertedNumber = double.parse(currentNumber);
        final newNumber = convertedNumber / 100;
        numberQueue.addLast(newNumber.toString());
      }
    }
    setState(() {});
  }

  final calculatorTextStyle = TextStyle();

  @override
  void initState() {
    // TODO: implement initState
    currentIcon = darkIcon;
    print(numberQueue);
    currentTheme = darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.backgoundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton.outlined(
              color: currentTheme.textColor,
              splashColor: Colors.black,
              hoverColor: Colors.black,
              onPressed: () {
                if (currentIcon == lightIcon) {
                  currentIcon = darkIcon;
                  currentTheme = darkTheme;
                } else {
                  currentIcon = lightIcon;
                  currentTheme = lightTheme;
                }

                setState(() {});
              },
              icon: Icon(
                currentIcon,
                color: currentTheme.screenColor,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: MediaQuery.of(context).size.height * 20 / 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.lightBlueAccent.withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: currentTheme.screenColor),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: double.infinity,
                        ),
                        Text(
                          numberQueue.isEmpty
                              ? "0"
                              : expressionQueue.isEmpty
                                  ? numberQueue.last
                                  : numberQueue.first,
                          style: GoogleFonts.shareTechMono(
                              color: currentTheme.textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          expressionQueue.isNotEmpty
                              ? expressionQueue.last
                              : "",
                          style: GoogleFonts.redHatMono(
                              color: currentTheme.textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          numberQueue.length < 2 ? "" : numberQueue.last,
                          style: GoogleFonts.shareTechMono(
                              color: currentTheme.textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Transform.rotate(
                        angle: 0.35,
                        child: UnconstrainedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  currentTheme.reflectionColor.withOpacity(0.4),
                            ),
                            width: 40,
                            height: 300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 15, mainAxisSpacing: 15, crossAxisCount: 4),
              children: [
                ElevatedButton(
                  onPressed: () {
                    Erase();
                  },
                  child: Text(
                    "C",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(8),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue; // Color when pressed
                        }
                        return Colors.red; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Percentage();
                  },
                  child: Icon(
                    Icons.percent,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Backspace();
                  },
                  child: Icon(
                    CupertinoIcons.delete_left,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickExpression("/");
                  },
                  child: Icon(
                    CupertinoIcons.divide,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("7");
                  },
                  child: Text(
                    "7",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("8");
                  },
                  child: Text(
                    "8",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("9");
                  },
                  child: Text(
                    "9",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickExpression("x");
                  },
                  child: Icon(
                    CupertinoIcons.multiply,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("4");
                  },
                  child: Text(
                    "4",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("5");
                  },
                  child: Text(
                    "5",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("6");
                  },
                  child: Text(
                    "6",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    AddMinus();
                  },
                  child: Icon(
                    CupertinoIcons.minus,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("1");
                  },
                  child: Text(
                    "1",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("2");
                  },
                  child: Text(
                    "2",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("3");
                  },
                  child: Text(
                    "3",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickExpression("+");
                  },
                  child: Icon(
                    CupertinoIcons.add,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Inverse();
                  },
                  child: Icon(
                    CupertinoIcons.minus_slash_plus,
                    size: 30,
                    weight: 30,
                    color: currentTheme.textColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ClickNumber("0");
                  },
                  child: Text(
                    "0",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    ToDouble();
                  },
                  child: Text(
                    ".",
                    style: GoogleFonts.overpassMono(
                        shadows: [
                          Shadow(
                            color: currentTheme.screenColor.withOpacity(0.8),
                            blurRadius: 30,
                          )
                        ],
                        color: currentTheme.textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: currentTheme.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Calculate();
                  },
                  child: Icon(
                    CupertinoIcons.equal,
                    size: 30,
                    weight: 30,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: Colors.yellowAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
