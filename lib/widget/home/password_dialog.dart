import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joujou_lounge/api/http_service.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/util/toasts.dart';
import 'package:http/http.dart' as Http;
import 'package:easy_localization/easy_localization.dart';

class PasswordDialog extends StatelessWidget {

  final VoidCallback _onNext;

  PasswordDialog({@required VoidCallback onNext})
      : _onNext = onNext;

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildContents(context),
        buildAppIcon(),
      ],
    );
  }

  Widget buildContents(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 56,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10))]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(tr("please_input_password"), style: TextStyle(color: Styles.appPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          TextField(
            controller: _passwordController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Styles.appBorderColorGrey, width: 1)
                ),
                hintText: tr("password"),
                hintStyle: TextStyle(color: Styles.appDisabledTextColor),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {Navigator.of(context).pop();},
                child: Text(tr("cancel"), style: TextStyle(fontSize: 16),),
              ),
              SizedBox(width: 10,),
              FlatButton(
                onPressed: () => verifyPassword(context),
                child: Text(tr("next"), style: TextStyle(color: Styles.appPrimaryColor, fontSize: 16),),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildAppIcon() {
    return Positioned(
      left: 16,
      right: 16,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40,
        child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              image: DecorationImage(
                image: AssetImage("assets/icon.png"),
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }

  Future<void> verifyPassword(BuildContext context) async {
    if (_passwordController.text.isNotEmpty) {
      Map<String, dynamic> params = Map<String, dynamic>();
      params['password'] = _passwordController.text;
      Http.Response response = await HttpService.post("checkPassword", params);
      if (response.statusCode != 200) {
        return ToastUtils.showErrorToast(context, tr("something_wrong_late"));
      }
      Map<String, dynamic> map = jsonDecode(response.body);
      if (map['status'] != null && map['status'] == "success") {
        Navigator.of(context).pop();
        _onNext();
      } else {
        return ToastUtils.showErrorToast(context, tr("invalid_password"));
      }
    } else {
      return ToastUtils.showErrorToast(context, tr("please_input_password"));
    }
  }
}
