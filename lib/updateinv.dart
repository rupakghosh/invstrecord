import 'inv.dart';
import 'invevent.dart';

class UpdateInv extends InvEvent {
  Inv newInv;
  int invIndex;

  UpdateInv(int index, Inv inv) {
    newInv = inv;
    invIndex = index;
  }
}