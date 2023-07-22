import 'package:flutter/material.dart';

class CustomLoadingBox extends StatefulWidget {
  @override
  State<CustomLoadingBox> createState() => _CustomLoadingBoxState();
}

class _CustomLoadingBoxState extends State<CustomLoadingBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      "Carregando...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
// return showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (BuildContext context) {
//     return Dialog(
//       child: new Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           new CircularProgressIndicator(),
//           new Text("Loading"),
//         ],
//       ),
//     );
//   },
// );}
// new Future.delayed(new Duration(seconds: 3), () {
//   Navigator.pop(context); //pop dialog
//   _login();
// });
}
