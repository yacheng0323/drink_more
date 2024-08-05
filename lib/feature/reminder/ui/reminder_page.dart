import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/show_snack_bar.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:drink_more/feature/reminder/bloc/reminder_bloc.dart';
import 'package:drink_more/feature/reminder/bloc/reminder_event.dart';
import 'package:drink_more/feature/reminder/bloc/reminder_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key, required this.seconds});
  final int seconds;

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late ReminderBloc bloc;

  @override
  void initState() {
    bloc = ReminderBloc(const ReminderState(status: ReminderStatus.initial));
    bloc.add(ReminderInit(seconds: widget.seconds));
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
          )),
      body: BlocProvider<ReminderBloc>(
        create: (context) => bloc,
        child: BlocConsumer<ReminderBloc, ReminderState>(
          listener: (context, state) {
            switch (state.status) {
              case ReminderStatus.initial:
                break;
              case ReminderStatus.success:
                ShowSnackBarHelper.successSnackBar(context: context).showSnackbar("Stage goal achieved!");
                Navigator.of(context).pop();

                break;
              case ReminderStatus.failure:
                break;
            }
          },
          builder: (context, state) {
            String displayTime = state.displayTime ?? "";
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
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(65, 48, 65, 0),
                      decoration: BoxDecoration(color: Color(0xffE8FCFF), border: Border.all(color: Color(0xff0079AC), width: 16), shape: BoxShape.circle),
                      child: Text(
                        displayTime,
                        style: TextGetter.headline4?.copyWith(color: Color(0xff2E2E2E)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Time to drink more！",
                        style: TextGetter.headline5?.copyWith(color: Color(0xff0079AC)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 64),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: DrinkMoreColors.buttonBackgroundColor,
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                constraints: const BoxConstraints(minHeight: 50),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.clear,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 60),
                          ElevatedButton(
                            onPressed: () {
                              bloc.add(Confirm(seconds: widget.seconds));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: DrinkMoreColors.buttonBackgroundColor,
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                constraints: const BoxConstraints(minHeight: 50),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.circle_outlined,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
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
