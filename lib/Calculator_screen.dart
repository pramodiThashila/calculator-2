import 'dart:math';

import 'package:flutter/material.dart';
import 'button_values.dart';
import 'package:flutter/cupertino.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  //statefull widget allow  change the dispaly base on user inputs
  const CalculatorScreen(
      {super.key}); //this is a constructor // key is to identify the widget in flutter widget tree

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState(); //return a instant of calculator screen
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  String expression = "";
  String calculationOnscreen = "";
  List<String> calculationHistory = [];

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; //get screen size to be responsive
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Add History as a tappable word at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to a history screen or display a dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(
                          history: calculationHistory, // Pass the history list
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //output

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display the current expression
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      calculationOnscreen.isEmpty
                          ? ""
                          : calculationOnscreen, // Show the full expression
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors
                            .grey, // Make it visually distinct from the result
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  // Display the result or the current input
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "$number1$operand$number2".isEmpty
                              ? "0"
                              : "$number1$operand$number2", // Display result
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //button
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 41, 44, 46), // Set your desired background color here
                borderRadius: BorderRadius.circular(
                    30), // Set the desired border radius here
              ),
              padding: const EdgeInsets.only(top: 16), // Add padding on top
              child: Wrap(
                children: Btn.buttonValues
                    .map((value) => SizedBox(
                        width: value == Btn.equal
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 4,
                        child: buildButton(value)))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget buildButton(value) {
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: Material(
  //       color: [
  //         //if
  //         Btn.delete,
  //         Btn.clear
  //       ].contains(value)
  //           ? Colors.blueGrey
  //           : [
  //               //elseif
  //               Btn.persentage,
  //               Btn.multiply,
  //               Btn.add,
  //               Btn.subtract,
  //               Btn.divide,
  //             ].contains(value) //else
  //               ? const Color.fromARGB(255, 35, 80, 163)
  //               : [Btn.equal].contains(value)
  //                   ? const Color.fromARGB(255, 104, 71, 165)
  //                   : const Color.fromARGB(221, 77, 75, 75),
  //       clipBehavior: Clip.hardEdge,
  //       shape: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
  //       child: InkWell(
  //         onTap: () {},
  //         child: Center(
  //             child: Text(
  //           value,
  //           style: const TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 30,
  //           ),
  //         )),
  //       ),
  //     ),
  //   );
  // }
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: [
          Btn.clear,
          Btn.allclear,
        ].contains(value)
            ? Colors.blueGrey
            : [
                Btn.persentage,
                Btn.multiply,
                Btn.add,
                Btn.subtract,
                Btn.divide,
              ].contains(value)
                ? const Color.fromARGB(255, 35, 80, 163)
                : [Btn.equal].contains(value)
                    ? Colors.blueGrey
                    : const Color.fromARGB(221, 58, 58, 58), // Default color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50), // Set desired border radius here
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          borderRadius: BorderRadius.circular(50), // Match the border radius
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white, // Ensure text color is visible
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.clear) {
      clear();
      return;
    }

    if (value == Btn.allclear) {
      clearAll();
      return;
    }

    if (value == Btn.persentage) {
      persentage(value);
      return;
    }

    if (value == Btn.equal) {
      calculate(value);
      return;
    }

    appendValue(value);
  }

  void clear() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1); //clear from num2
    } else if (operand.isNotEmpty) {
      operand = ""; //clear the operand
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1); //clear the num2
    }

    expression =
        expression.substring(0, expression.length - 1); //clear from expression

    calculationOnscreen = expression;

    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1 = "";
      number2 = "";
      operand = "";
      expression = "";
      calculationOnscreen = "";
    });
  }

  void persentage(String value) {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //calculate before convert
      calculate(value);
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  //calculate the result
  void calculate(String value) {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    double num1, num2;
    try {
      num1 = double.parse(number1);
      num2 = double.parse(number2);
    } catch (e) {
      print("Error parsing numbers: $e");
      return; // Stop calculation if parsing fails
    }

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      if (value == Btn.equal) {
        // Store the full calculation in history
        calculationHistory.add("$expression = $number1");
        // Reset expression for next calculation
        calculationOnscreen = expression;
        expression = number1;
      }

      operand = "";
      number2 = "";
    });
  }

  //append value to the end
  void appendValue(String value) {
    //if operand is not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      //operannd presses
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate(value);
      }
      operand = value;
      expression += value;
      calculationOnscreen = expression;

      print(" $expression");
    } //assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      //number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        //number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
      expression += value;
      calculationOnscreen = expression;

      print(" $expression");
    } // assign value to number 2
    else if (number2.isEmpty || operand.isNotEmpty) {
      //number2 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        //number2 = "" | "0"
        value = "0.";
      }
      number2 += value;
      expression += value;
      calculationOnscreen = expression;

      print(" $expression");
    }

    setState(() {});
  }
}
