import 'invdb.dart';
import 'deleteinv.dart';
import 'setinv.dart';
import 'invform.dart';
import 'inv.dart';
import 'package:flutter/material.dart';
import 'invbl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'invbl.dart';

class InvList extends StatefulWidget {
  const InvList({Key key}) : super(key: key);

  @override
  _InvListState createState() => _InvListState();
}

class _InvListState extends State<InvList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getInvs().then(
          (invList) {
        BlocProvider.of<InvBloc>(context).add(SetInvs(invList));
      },
    );
  }

  showInvDialog(BuildContext context, Inv inv, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(inv.schname),
        content: Text("Sl No. ${inv.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InvForm(inv: inv, invIndex: index),
              ),
            ),
            child: Text("Update Record"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(inv.id).then((_) {
              BlocProvider.of<InvBloc>(context).add(
                DeleteInv(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete Record"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Move Back"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Preparing");
    return Scaffold(
      appBar: AppBar(title: Text("Investement Records")),
      body: Container(
        child: BlocConsumer<InvBloc, List<Inv>>(
          builder: (context, invList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("invList: $invList");

                Inv inv = invList[index];
                return ListTile(
                    title: Text(inv.schname, style: TextStyle(fontSize: 30, color: Colors.brown)),
                    subtitle: Text(
                      "Investement Type: ${inv.type}\nAmount Invested: ${inv.amount}\nDue Time Period(in years): ${inv.year}\n Issuing Date(i.e. 22nd June,2020): ${inv.date}\nMaturity: ${inv.isMatured}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showInvDialog(context, inv, index));
              },
              itemCount: invList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.brown),
            );
          },
          listener: (BuildContext context, invList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => InvForm()),
        ),
      ),
    );
  }
}