import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/datetime_usecase.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/show_snack_bar.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_bloc.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_event.dart';
import 'package:drink_more/feature/init/bloc/init_stage_goal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InitStageGoalPage extends StatefulWidget {
  const InitStageGoalPage({super.key, required this.dailyGoal});

  final double dailyGoal;

  @override
  State<InitStageGoalPage> createState() => _InitStageGoalPageState();
}

class _InitStageGoalPageState extends State<InitStageGoalPage> {
  late InitStageGoalBloc bloc;
  TextEditingController controller = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    bloc = InitStageGoalBloc(InitStageGoalState(status: InitStageGoalStatus.initial));
    super.initState();
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
      body: BlocProvider<InitStageGoalBloc>(
          create: (context) => bloc,
          child: BlocConsumer<InitStageGoalBloc, InitStageGoalState>(
            builder: (context, state) {
              final times = state.scheduledTimes ?? [];
              return Form(
                key: formKey,
                child: Stack(
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
                                "Set your stage goal",
                                style: TextGetter.headline5?.copyWith(
                                  color: const Color(0xff5A5A5A),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.0),
                                  gradient: const LinearGradient(
                                    stops: [0.0, 0.02, 0.1, 0.2],
                                    colors: [
                                      Color(0xff5698BD),
                                      Color(0xffACD2E4),
                                      Color(0xffC1DFED),
                                      Color(0xffE9F8FE),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      controller.text = value;
                                    });
                                  },
                                  controller: controller,
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
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                "Set daily reminder time",
                                style: TextGetter.headline5?.copyWith(color: DrinkMoreColors.contentTextColor),
                              ),
                              const Spacer(),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xff2CBAD4),
                                child: IconButton(
                                  onPressed: () {
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
                                                              bloc.add(AddTime(dateTime: (DateFormat("a        hh:mm").parse(timeController.text))));
                                                              Navigator.of(context).pop();
                                                            },
                                                            text: 'Add',
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
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 130),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(32, 24, 80, 24),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  margin: const EdgeInsets.only(bottom: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.clear,
                                          color: DrinkMoreColors.clearIconColor,
                                          size: 32,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("a       hh:mm").format(DatetimeUsecase.timeFromSeconds(times[index])),
                                        style: TextGetter.headline5?.copyWith(color: const Color(0xff787878)),
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: times.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                    times.isNotEmpty
                        ? Positioned(
                            bottom: 64,
                            child: GradientButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  bloc.add(Submit(dailyGoal: widget.dailyGoal, stageGoal: double.parse(controller.text), scheduledTimes: times));
                                }
                              },
                              text: 'Start',
                              textStyle: TextGetter.bodyText1?.copyWith(color: Colors.white),
                              gradient: DrinkMoreColors.buttonBackgroundColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
            listener: (context, state) {
              switch (state.status) {
                case InitStageGoalStatus.initial:
                  break;
                case InitStageGoalStatus.success:
                  context.go("/NavScaffold");

                  break;
                case InitStageGoalStatus.addTimeSuccess:
                  break;
                case InitStageGoalStatus.addTimeFailure:
                  ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Cannot add duplicate times");

                  break;
                case InitStageGoalStatus.startError:
                  ShowSnackBarHelper.errorSnackBar(context: context).showSnackbar("Unidentified Failure");

                  break;
                case InitStageGoalStatus.loading:
                  break;
              }
            },
          )),
    );
  }
}
