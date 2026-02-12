import 'package:flutter/material.dart';

class CustomFantasyCard extends StatelessWidget {
  final double? stackRight;
  final double? stackleft;
  final double? stackTop;
  final double? stackBottom;
  final double? height;
  final Widget bgWidget;
  final Widget textWidget;
  final Widget textWidget2;
  final String? buttonText;
  final void Function()? onPressed;

  const CustomFantasyCard({
    super.key,
    this.stackRight,
    this.stackleft,
    this.stackTop,
    this.stackBottom,
    this.height,
    required this.bgWidget,
    required this.textWidget,
    required this.textWidget2,
    this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      height: 200,
      width: 360,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: stackRight,
            top: stackTop,
            child: bgWidget,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: textWidget,
                  // Text(
                  //   "Play Stock Fantasy",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 39,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget2,
                        // Text(
                        //   "Play with your friends by \ncreating private leagues",
                        //   maxLines: 3,
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w300,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          color: Color(0xff5AA771),
                          onPressed: onPressed,
                          child: Text(
                            "$buttonText",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                      // SizedBox(width: 10),
                      // SizedBox(
                      //   height: 50,
                      //   child: MaterialButton(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(50.0),
                      //     ),
                      //     color: Color(0xff5AA771),
                      //     onPressed: () {},
                      //     child: Text(
                      //       "Join a fantasy",
                      //       style: TextStyle(fontSize: 13, color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
