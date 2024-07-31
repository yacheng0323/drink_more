import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/datetime_usecase.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_bloc.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_event.dart';
import 'package:drink_more/feature/drinkhome/bloc/drink_more_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DrinkMorePage extends StatefulWidget {
  const DrinkMorePage({super.key});

  @override
  State<DrinkMorePage> createState() => _DrinkMorePageState();
}

class _DrinkMorePageState extends State<DrinkMorePage> {
  late DrinkMoreBloc bloc;
  TextEditingController amountController = TextEditingController();

  TextEditingController timeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  @override
  void initState() {
    bloc = DrinkMoreBloc(DrinkMoreState(status: DrinkMoreStatus.initial));
    bloc.add(DrinkMoreInit());
    super.initState();
  }

  @override
  void dispose() {
    timeController.dispose();
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
        body: BlocProvider<DrinkMoreBloc>(
          create: (context) => bloc,
          child: BlocConsumer<DrinkMoreBloc, DrinkMoreState>(
            listener: (context, state) {
              switch (state.status) {
                case DrinkMoreStatus.initial:
                  break;
                case DrinkMoreStatus.success:
                  break;
                case DrinkMoreStatus.failure:
                  break;
                case DrinkMoreStatus.loading:
                  break;
              }
            },
            builder: (context, state) {
              Widget widget = Container();
              double dailyGoal = state.dailyGoal ?? 0;
              double amount = state.amount ?? 0;
              List<int> scheduledTimes = state.scheduledTimes ?? [];
              switch (state.status) {
                case DrinkMoreStatus.initial:
                  widget = Container();
                  break;
                case DrinkMoreStatus.success:
                  widget = Stack(
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
                                  amount.toStringAsFixed(0),
                                  style: TextGetter.headline3?.copyWith(color: Color(0xff0079AC), fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "/${dailyGoal.toStringAsFixed(0)}ml",
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
                                        "${((amount / dailyGoal) * 100).toStringAsFixed(0)}%",
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
                                    child: StepProgressIndicator(
                                      totalSteps: 100,
                                      currentStep: ((amount / dailyGoal) * 100).clamp(0, 100).toInt(),
                                      size: 46,
                                      padding: 0,
                                      unselectedColor: Colors.cyan,
                                      roundedEdges: const Radius.circular(10),
                                      selectedGradientColor: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Color(0xff2FB6CF), Color(0xff2CBAD4), Color(0xff2290CE)],
                                      ),
                                      unselectedGradientColor: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xff7BCBE4), Color(0xff7BCBE4)],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 24),
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: GradientButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Form(
                                              key: formKey,
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
                                                        "Extra drinking",
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
                                                          controller: amountController,
                                                          textAlign: TextAlign.center,
                                                          style: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor, fontWeight: FontWeight.w500),
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(4),
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*')),
                                                          ],
                                                          validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return "Please enter your water intake amount";
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
                                                                  if (formKey.currentState!.validate()) {
                                                                    bloc.add(AddMoreRecord(amount: double.parse(timeController.text)));
                                                                    Navigator.of(context).pop();
                                                                  }
                                                                },
                                                                text: 'Save',
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
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xffA0CDD5)),
                                                height: 208,
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
                                                      padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
                                                      child: TextFormField(
                                                        controller: timeController,
                                                        style: TextGetter.headline5?.copyWith(color: DrinkMoreColors.textFieldTextColor, fontWeight: FontWeight.w500),
                                                        readOnly: true,
                                                        onTap: () async {
                                                          final result = await DatePicker.showTimePicker(showSecondsColumn: false, context);
                                                          if (result != null) {
                                                            setState(() {
                                                              timeController.text = DateFormat('a        hh:mm').format(result);
                                                            });
                                                          }
                                                        },
                                                        decoration: InputDecoration(
                                                          suffixStyle: TextGetter.headline5?.copyWith(color: DrinkMoreColors.contentTextColor),
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                                          fillColor: Colors.white,
                                                          filled: true,
                                                          hintText: "Select time",
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
                                                                //** 刪除還沒實作 */
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style: TextGetter.bodyText1?.copyWith(color: Color(0xff0079AC)),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: GradientButton(
                                                              onPressed: () {
                                                                final date = DateFormat("a        hh:mm").parse(timeController.text);
                                                                int hour = date.hour;
                                                                int minute = date.minute;
                                                                int totalSeconds = hour * 3600 + minute * 60;
                                                                bloc.add(UpdateScheduledTimes(id: index, second: totalSeconds));
                                                                Navigator.of(context).pop();
                                                              },
                                                              text: 'Save',
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
                                            );
                                          });
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
                                              DateFormat("a  hh:mm").format(DatetimeUsecase.timeFromSeconds(scheduledTimes[index])),
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
                                itemCount: scheduledTimes.length,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                  break;
                case DrinkMoreStatus.failure:
                  widget = Container();

                  break;
                case DrinkMoreStatus.loading:
                  widget = Container();

                  break;
              }
              return widget;
            },
          ),
        ));
  }
}
