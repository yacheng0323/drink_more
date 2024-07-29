import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DrinkMorePage extends StatefulWidget {
  const DrinkMorePage({super.key});

  @override
  State<DrinkMorePage> createState() => _DrinkMorePageState();
}

class _DrinkMorePageState extends State<DrinkMorePage> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentIndex = 0;

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
              gradient: LinearGradient(
                colors: [
                  DrinkMoreColors.backgroundTopColor,
                  DrinkMoreColors.backgroundBottomColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1200",
                      style: TextGetter.headline3?.copyWith(color: Color(0xff0079AC), fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Text(
                          "/2700ml",
                          style: TextGetter.headline5?.copyWith(color: Color(0xff2E2E2E), fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xff2FB6CF),
                              Color(0xff2CBAD4),
                              Color(0xff2290CE),
                            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Text(
                            "43%",
                            style: TextGetter.headline6?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        clipBehavior: Clip.antiAlias,
                        child: const StepProgressIndicator(
                          totalSteps: 100,
                          currentStep: 43,
                          size: 46,
                          padding: 0,
                          unselectedColor: Colors.cyan,
                          roundedEdges: Radius.circular(10),
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff2FB6CF), Color(0xff2CBAD4), Color(0xff2290CE)],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff7BCBE4), Color(0xff7BCBE4)],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 24),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: GradientButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        text: "Add more record",
                        textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                        gradient: DrinkMoreColors.buttonBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
                child: Text(
                  "The Coming Reminder",
                  style: TextGetter.headline5?.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print("$index");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "pm $index",
                                  textAlign: TextAlign.center,
                                  style: TextGetter.headline5?.copyWith(color: const Color(0xff5A5A5A), fontWeight: FontWeight.w700),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Symbols.edit_square_rounded,
                                  color: Color(0xff0079AC),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 5,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
