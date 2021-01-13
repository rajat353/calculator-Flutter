import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import "Widget/Button.dart";
import 'package:math_expressions/math_expressions.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyState();
}

class BodyState extends State<Body> {
  String history = '';
  String expression = '';
  String result = "0";
  bool decimalFlag = false;
  bool resultFlag = true;

  bool isSym(String expression) {
    if (expression.endsWith('+') ||
        expression.endsWith('-') ||
        expression.endsWith('*') ||
        expression.endsWith('/') ||
        expression.endsWith('%')) return true;
    return false;
  }

  String calculate(String expression) {
    String temp = expression;
    if (isSym(temp)) temp = temp.substring(0, temp.length - 1);
    Parser p = Parser();
    Expression exp = p.parse(temp);
    ContextModel cm = ContextModel();
    result = "=" + double.parse(exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(10)).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    return result;
  }

  void exit(String text) {
    SystemNavigator.pop();
  }

  void clickDecimal(String text) {
    if (!expression.endsWith('.') && !decimalFlag)
      setState(() {
        resultFlag = false;
        if (isSym(expression) || expression == '') {
          decimalFlag = true;
          expression += "0" + text;
        } else {
          decimalFlag = true;
          expression += text;
        }
      });
  }

  void clickNum(String text) {
    expression += text;
    setState(() {
      resultFlag = false;
      result = calculate(expression);
    });
  }

  void clickSym(String text) {
    if (expression.endsWith('.'))
      expression = expression.substring(0, expression.length - 1);
    if (!isSym(expression) && expression != '')
      setState(() {
        resultFlag = false;
        decimalFlag = false;
        expression += text;
      });
  }

  void delete(String text) {
    if (expression.endsWith('.')) decimalFlag = false;
    if (isSym(expression)) decimalFlag = false;
    if (expression != '')
      setState(() {
        resultFlag = false;
        if (expression.length == 1) {
          expression = '';
          result = '0';
        } else if (expression.endsWith('0.')) {
          expression = expression.substring(0, expression.length - 2);
        } else {
          expression = expression.substring(0, expression.length - 1);
          calculate(expression);
        }
      });
  }

  void clearExpression(String text) {
    setState(() {
      resultFlag = false;
      decimalFlag = false;
      expression = "";
      result = "0";
    });
  }

  void clearAll(String text) {
    setState(() {
      resultFlag = false;
      decimalFlag = false;
      expression = "";
      history = "";
      result = "0";
    });
  }

  void evaluate(String text) {
    setState(() {
      resultFlag = true;
      result = calculate(expression);
      history = history + "\n" + expression + result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double size=sqrt(height*height + width*width);
    return Container(
        padding: EdgeInsets.only(top: 20),
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
            reverse: true,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        history,
                        style: TextStyle(fontSize: size * 0.03),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        expression,
                        style: TextStyle(
                            fontSize: !resultFlag ? size * 0.06 : size * 0.05,
                            color:
                                !resultFlag ? Colors.black : Colors.grey[700]),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        result,
                        style: TextStyle(
                            fontSize: resultFlag ? size * 0.06 : size * 0.05,
                            color:
                                resultFlag ? Colors.black : Colors.grey[700]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Button(
                            text: expression == "" ? "AC" : "C",
                            textColor: 0xFFE65100,
                            callButton:
                                expression == "" ? clearAll : clearExpression,
                          ),
                          Button(
                            text: "<×",
                            textColor: 0xFFE65100,
                            callButton: delete,
                          ),
                          Button(
                            text: "%",
                            textColor: 0xFFE65100,
                            callButton: clickSym,
                          ),
                          Button(
                            text: "/",
                            textColor: 0xFFE65100,
                            callButton: clickSym,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          Button(
                            text: "7",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "8",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "9",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "*",
                            callButton: clickSym,
                            textColor: 0xFFE65100,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          Button(
                            text: "4",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "5",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "6",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "-",
                            textColor: 0xFFE65100,
                            callButton: clickSym,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          Button(
                            text: "1",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "2",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "3",
                            callButton: clickNum,
                          ),
                          Button(
                            text: "+",
                            textColor: 0xFFE65100,
                            callButton: clickSym,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Row(
                        children: <Widget>[
                          Button(
                            text: "💀",
                            callButton: exit,
                            textSize: 20,
                          ),
                          Button(
                            text: "0",
                            callButton: clickNum,
                          ),
                          Button(text: ".", callButton: clickDecimal),
                          Button(
                              text: "=",
                              textSize: 40,
                              textColor: 0xFFFFFFFF,
                              fillColor: 0xFFE65100,
                              callButton: evaluate)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ]),
                  )
                ])));
  }
}
