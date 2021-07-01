import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {

  final VoidCallback _onClick;

  BackButtonWidget(this._onClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onClick,
      child: Container(
        width: 66,
        height: 66,
        padding: const EdgeInsets.only(top: 3, left: 3, bottom: 3, right: 0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(36)),
        ),
        child: Container(
          width: 63,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(36)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 36,),
          ),
        ),
      ),
    );
  }
}
