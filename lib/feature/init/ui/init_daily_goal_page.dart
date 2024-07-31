import 'package:drink_more/core/database/database_service.dart';
import 'package:drink_more/core/ui/color.dart';
import 'package:drink_more/core/ui/gradient_button.dart';
import 'package:drink_more/core/ui/textstyle.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class InitDailyGoalPage extends StatefulWidget {
  const InitDailyGoalPage({super.key});

  @override
  State<InitDailyGoalPage> createState() => _InitDailyGoalPageState();
}

class _InitDailyGoalPageState extends State<InitDailyGoalPage> {
  late InitDailyGoalBloc bloc;
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  @override
  void initState() {
    bloc = InitDailyGoalBloc(InitDailyGoalState(status: InitDailyGoalStatus.init));
    bloc.add(Init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InitDailyGoalBloc>(
      create: (context) => bloc,
      child: BlocConsumer<InitDailyGoalBloc, InitDailyGoalState>(
        listener: (context, state) {
          if (state.status == InitDailyGoalStatus.hasData) {
            context.go('/NavScaffold');
          }
        },
        builder: (context, state) {
          if (state.status == InitDailyGoalStatus.noData) {
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
              body: Form(
                key: formKey,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(gradient: DrinkMoreColors.gradientBackgroundColor),
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
                                "Set your daily goal",
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.push("/InitStageGoal", extra: double.parse(controller.text));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: DrinkMoreColors.buttonBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(64, 0, 64, 0),
                            constraints: const BoxConstraints(minHeight: 44.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Continue',
                              style: TextGetter.bodyText1?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: const BoxDecoration(gradient: DrinkMoreColors.gradientBackgroundColor),
            );
          }
        },
      ),
    );
  }
}

class InitDailyGoalBloc extends Bloc<InitDailyGoalEvent, InitDailyGoalState> {
  InitDailyGoalBloc(super.initialState) {
    on<Init>(checkDataExists);
  }

  Future<void> checkDataExists(
    Init event,
    Emitter<InitDailyGoalState> emit,
  ) async {
    try {
      final dbService = GetIt.I.get<DatabaseService>();
      final result = await dbService.hasTableData("WaterGoals");
      if (result) {
        emit.call(state.copyWith(status: InitDailyGoalStatus.hasData));
      } else {
        emit.call(state.copyWith(status: InitDailyGoalStatus.noData));
      }
    } catch (e) {
      emit.call(state.copyWith(status: InitDailyGoalStatus.noData));
    }
  }
}

abstract class InitDailyGoalEvent {}

class Init extends InitDailyGoalEvent {}

class InitDailyGoalState extends Equatable {
  final InitDailyGoalStatus status;

  const InitDailyGoalState({
    this.status = InitDailyGoalStatus.noData,
  });

  InitDailyGoalState copyWith({
    InitDailyGoalStatus? status,
  }) {
    return InitDailyGoalState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [];
}

enum InitDailyGoalStatus {
  init,
  noData,
  hasData,
}
