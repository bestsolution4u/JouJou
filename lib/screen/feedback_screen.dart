import 'package:flutter/material.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';
import 'package:joujou_lounge/widget/label_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 120,),
              Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    tr("feedback"),
                    style: TextStyle(
                        color: Styles.appPrimaryColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 60,),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: MetaRepository.getMetaValue("feedback"),
                    builder: (context, snapshot) {
                      if (snapshot.data == null || snapshot.data.isEmpty) {
                        return Container();
                      }
                      return Html(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        data: snapshot.data,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  LabelButtonWidget(
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 36),
                      _onBackPressed),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }
}
