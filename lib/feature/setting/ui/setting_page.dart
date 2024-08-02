import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/show_snack_bar.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/setting/bloc/setting_bloc.dart';
import 'package:drink_more/feature/setting/bloc/setting_event.dart';
import 'package:drink_more/feature/setting/bloc/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingBloc bloc;
  TextEditingController dailyGoalController = TextEditingController();
  final dailyFormKey = GlobalKey<FormState>();
  TextEditingController stageGoalController = TextEditingController();
  final stageFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    bloc = SettingBloc(const SettingState(status: SettingStatus.initial));
    bloc.add(SettingInit());
    super.initState();
  }

  @override
  void dispose() {
    dailyGoalController.dispose();
    super.dispose();
  }

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
      body: BlocProvider<SettingBloc>(
        create: (context) => bloc,
        child: BlocConsumer<SettingBloc, SettingState>(
          listener: (context, state) {
            switch (state.status) {
              case SettingStatus.saveDailyGoalSuccess:
                ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("Daily goal saved");
                break;
              case SettingStatus.saveDailyGoalFailure:
                ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Failed to save daily goal");

                break;
              case SettingStatus.saveStageGoalSuccess:
                ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("Stage goal saved");
              case SettingStatus.saveStageGoalFailure:
                ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Failed to save stage goal");
              default:
                break;
            }
          },
          builder: (context, state) {
            double dailyGoal = state.dailyGoal ?? 0;
            double stageGoal = state.stageGoal ?? 0;

            return Stack(
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
                      padding: const EdgeInsets.all(32),
                      child: GradientButton(
                          onPressed: () {
                            dailyGoalController.text = dailyGoal.toStringAsFixed(0);

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Form(
                                    key: dailyFormKey,
                                    child: Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffA0CDD5)),
                                        height: 270,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(
                                                  Icons.clear,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Edit your Daily Goal",
                                              style: TextGetter.headline6?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                gradient: const LinearGradient(
                                                  stops: [0.0, 0.05, 0.1, 0.2],
                                                  colors: [
                                                    Color(0xff5698BD),
                                                    Colors.white,
                                                    Colors.white,
                                                    Colors.white,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: TextFormField(
                                                controller: dailyGoalController,
                                                textAlign: TextAlign.center,
                                                style: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor, fontWeight: FontWeight.w500),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(4),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*')),
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter your daily goal";
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  suffixText: "ml",
                                                  suffixStyle: TextGetter.headline5?.copyWith(color: DrinkMoreColors.contentTextColor),
                                                  hintStyle: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor),
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        backgroundColor: const Color(0xffA0CDD5),
                                                        side: const BorderSide(color: Color(0xff0079AC), width: 2),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextGetter.bodyText1?.copyWith(color: Color(0xff0079AC)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: GradientButton(
                                                      onPressed: () {
                                                        if (dailyFormKey.currentState!.validate()) {
                                                          bloc.add(SaveDailyGoal(amount: double.parse(dailyGoalController.text)));
                                                          Navigator.of(context).pop();
                                                        }
                                                      },
                                                      text: "Save",
                                                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                                      textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                                                      gradient: DrinkMoreColors.buttonBackgroundColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          text: "Edit Daily Goal",
                          textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                          gradient: DrinkMoreColors.buttonBackgroundColor),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: GradientButton(
                          onPressed: () {
                            stageGoalController.text = stageGoal.toStringAsFixed(0);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Form(
                                    key: stageFormKey,
                                    child: Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffA0CDD5)),
                                        height: 270,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(
                                                  Icons.clear,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Edit your Stage Goal",
                                              style: TextGetter.headline6?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                gradient: const LinearGradient(
                                                  stops: [0.0, 0.05, 0.1, 0.2],
                                                  colors: [
                                                    Color(0xff5698BD),
                                                    Colors.white,
                                                    Colors.white,
                                                    Colors.white,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: TextFormField(
                                                controller: stageGoalController,
                                                textAlign: TextAlign.center,
                                                style: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor, fontWeight: FontWeight.w500),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(4),
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*')),
                                                ],
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Please enter your stage goal";
                                                  }
                                                },
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  suffixText: "ml",
                                                  suffixStyle: TextGetter.headline5?.copyWith(color: DrinkMoreColors.contentTextColor),
                                                  hintStyle: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor),
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        backgroundColor: const Color(0xffA0CDD5),
                                                        side: const BorderSide(color: Color(0xff0079AC), width: 2),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextGetter.bodyText1?.copyWith(color: Color(0xff0079AC)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: GradientButton(
                                                      onPressed: () {
                                                        if (stageFormKey.currentState!.validate()) {
                                                          bloc.add(SaveStageGoal(amount: double.parse(stageGoalController.text)));
                                                          Navigator.of(context).pop();
                                                        }
                                                      },
                                                      text: "Save",
                                                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                                      textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                                                      gradient: DrinkMoreColors.buttonBackgroundColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          text: "Edit Stage Goal",
                          textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                          gradient: DrinkMoreColors.buttonBackgroundColor),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 64, 32, 0),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color(0xff0079AC),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "Reset All Data",
                          style: TextGetter.bodyText1?.copyWith(color: const Color(0xff0079AC)),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Form(
                                  key: stageFormKey,
                                  child: Dialog(
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffA0CDD5)),
                                      height: 230,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Reset",
                                              style: TextGetter.headline6?.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(32, 8, 32, 0),
                                            alignment: Alignment.centerLeft,
                                            child: Text("All the data will be cleared.\nAre you sure to reset it?"),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      backgroundColor: const Color(0xffA0CDD5),
                                                      side: const BorderSide(color: Color(0xff0079AC), width: 2),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      "No",
                                                      style: TextGetter.bodyText1?.copyWith(color: Color(0xff0079AC)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: GradientButton(
                                                    onPressed: () {
                                                      bloc.add(Reset());
                                                      context.go("/");
                                                    },
                                                    text: "Yes",
                                                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                                    textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                                                    gradient: DrinkMoreColors.buttonBackgroundColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
