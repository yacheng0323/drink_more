import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "DRINK MORE",
          style: TextGetter.headline5?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: DrinkMoreColors.gradientBackgroundColor,
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(32),
                child: GradientButton(onPressed: () {}, text: "Edit Daily Goal", textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white), gradient: DrinkMoreColors.buttonBackgroundColor),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: GradientButton(onPressed: () {}, text: "Edit Stage Goal", textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white), gradient: DrinkMoreColors.buttonBackgroundColor),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(32, 64, 32, 0),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Color(0xff0079AC),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    "Reset All Data",
                    style: TextGetter.bodyText1?.copyWith(color: Color(0xff0079AC)),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
