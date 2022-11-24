import 'package:flutter/material.dart';
import 'package:example/you_awesome/index.dart';


class YouAwesomePage extends StatefulWidget {
  const YouAwesomePage({
    required this.bloc,
    super.key
    });
  static const String routeName = '/youAwesome';
  
  final YouAwesomeBloc bloc;

  @override
  State<YouAwesomePage> createState() => _YouAwesomePageState();
}

class _YouAwesomePageState extends State<YouAwesomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('YouAwesome'),
         actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              widget.bloc.add(AddYouAwesomeEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              widget.bloc.add(ClearYouAwesomeEvent());
            },
          ),
        ],
      ),
      body: YouAwesomeScreen(bloc: widget.bloc),
    );
  }
}
