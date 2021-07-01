import 'package:flutter/material.dart';

class MainSelectButton extends StatelessWidget {

  final Icon _icon;
  final String _text;
  final VoidCallback _onClick;

  MainSelectButton(this._icon, this._text, this._onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onClick,
        splashColor: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(80),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 140,
            height: 140,
            child: ClipOval(
              child: Material(
                color: Colors.lightBlueAccent,
                shape: CircleBorder(
                    side: BorderSide(
                        width: 5,
                        color: Colors.white
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _icon,
                    SizedBox(height: 10,),
                    Text(_text, style: TextStyle(color: Colors.white, fontSize: 18),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
