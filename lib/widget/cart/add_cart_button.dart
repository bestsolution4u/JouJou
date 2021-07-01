import 'package:flutter/material.dart';
import 'package:joujou_lounge/constant/style.dart';

class AddCartButton extends StatelessWidget {
  final VoidCallback _onClicked;

  AddCartButton({@required VoidCallback onClicked})
      : _onClicked = onClicked,
        super();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onClicked ?? _onClickedDef,
        borderRadius: BorderRadius.circular(40),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Styles.appSecondaryColor.withOpacity(0.2),
                  blurRadius: 2.0,
                ),
              ]),
              child: Icon(
                Icons.add_circle,
                color: Styles.appSecondaryColor,
                size: 40,
              )),
        ),
      ),
    );
  }

  void _onClickedDef() {}
}
