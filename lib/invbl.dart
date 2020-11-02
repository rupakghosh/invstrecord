import 'addinv.dart';
import 'deleteinv.dart';
import 'invevent.dart';
import 'setinv.dart';
import 'updateinv.dart';
import 'inv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvBloc extends Bloc<InvEvent, List<Inv>> {
  @override
  List<Inv> get initialState => List<Inv>();

  @override
  Stream<List<Inv>> mapEventToState(InvEvent event) async* {
    if (event is SetInvs) {
      yield event.invList;
    } else if (event is AddInv) {
      List<Inv> newState = List.from(state);
      if (event.newInv != null) {
        newState.add(event.newInv);
      }
      yield newState;
    } else if (event is DeleteInv) {
      List<Inv> newState = List.from(state);
      newState.removeAt(event.invIndex);
      yield newState;
    } else if (event is UpdateInv) {
      List<Inv> newState = List.from(state);
      newState[event.invIndex] = event.newInv;
      yield newState;
    }
  }
}