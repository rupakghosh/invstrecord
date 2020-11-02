import 'inv.dart';

import 'invevent.dart';

class SetInvs extends InvEvent {
  List<Inv> invList;

  SetInvs(List<Inv> invs) {
    invList = invs;
  }
}