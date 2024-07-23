import 'package:flutter/material.dart';

class InitStageGoalPage extends StatefulWidget {
  const InitStageGoalPage({super.key});

  @override
  State<InitStageGoalPage> createState() => _InitStageGoalPageState();
}

class _InitStageGoalPageState extends State<InitStageGoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Init Stage Goal"),
      ),
      body: const Placeholder(),
    );
  }
}
