import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class Button extends StatelessWidget {
  final String text;
  final int fillColor;
  final int textColor;
  final double textSize;
  final Function callButton;

  const Button({
    this.text,
    this.fillColor=0xFF000000,
    this.textColor=0xFFFFFFFF,
    this.textSize=30,
    this.callButton
  });
  
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Container(
      
        height: height*0.1,
        width: width*0.25,
        color: Color(fillColor),
        child: FlatButton(
          splashColor: Colors.grey[900],
          padding: EdgeInsets.all(2),
            child: Text(text,
                style: GoogleFonts.lato(textStyle: TextStyle(color: Color(textColor), fontSize: textSize))),
            onPressed: ()=>callButton(text)));
  }
}
