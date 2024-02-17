import 'package:flutter/material.dart';

class CustomLoadingBox extends StatelessWidget {
  const CustomLoadingBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Container(
          width: 300.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 7.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Carregando...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}