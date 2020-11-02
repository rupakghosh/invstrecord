import 'invevent.dart';

class DeleteInv extends InvEvent {
  int invIndex;

  DeleteInv(int index) {
    invIndex = index;
  }
}