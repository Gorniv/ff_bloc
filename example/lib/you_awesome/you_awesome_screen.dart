import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/you_awesome/index.dart';


class YouAwesomeScreen extends StatefulWidget {
  const YouAwesomeScreen({
    required this.bloc,
    super.key,
  }) ;

  @protected
  final YouAwesomeBloc bloc;

  @override
  State<YouAwesomeScreen> createState() {
    return YouAwesomeScreenState();
  }
}

class YouAwesomeScreenState extends State<YouAwesomeScreen> {

  @override
  void initState() {
    super.initState();
    if (!widget.bloc.state.hasData) {
      _load();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YouAwesomeBloc, YouAwesomeState>(
      bloc: widget.bloc,
      builder: (
        BuildContext context,
        YouAwesomeState currentState,
      ) {
        return currentState.when(
          onLoading: ()=>const CircularProgressIndicator(),
          onEmpty: (data) =>  _Empty(),
          onData: (data) =>  _BodyList(data: data),
          onError: (e) =>  Center(
            child: Column(
              children: [
                Text(e.toString()),
                TextButton(
                  onPressed: _load,
                  child: const Text('ReLoad'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _load() {
    widget.bloc.add(LoadYouAwesomeEvent(id:'1'));
  }

}


class _BodyList extends StatefulWidget {
  const _BodyList({required this.data});

  final YouAwesomeViewModel data;

  @override
  State<_BodyList> createState() => _BodyListState();
}

class _BodyListState extends State<_BodyList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
        // primary: true,
        slivers: [
          const SliverToBoxAdapter(child: Divider()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
          final item = widget.data.items![index];
          if (index == 0) {
            return Text('Header $index, id = '+item.name);
          }
          return Text('Index = $index, id = '+item.name);
        },
        childCount: widget.data.items!.length,
    ))]);
  }
}


class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Empty'),
      ],
    );
  }
}