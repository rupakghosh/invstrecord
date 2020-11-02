import 'invlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'invbl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvBloc>(
      create: (context) => InvBloc(),
      child: MaterialApp(
        title: 'Investemnt Records',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: InvList(),
      ),
    );
  }
}