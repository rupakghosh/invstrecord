import 'inv.dart';

import 'invevent.dart';

class AddInv extends InvEvent {
  Inv newInv;

  AddInv(Inv inv) {
    newInv = inv;
  }
}