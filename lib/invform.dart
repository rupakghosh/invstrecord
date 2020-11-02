import 'invbl.dart';
import 'invdb.dart';
import 'addinv.dart';
import 'updateinv.dart';
import 'inv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvForm extends StatefulWidget {
  final Inv inv;
  final int invIndex;

  InvForm({this.inv, this.invIndex});

  @override
  State<StatefulWidget> createState() {
    return InvFormState();
  }
}

class InvFormState extends State<InvForm> {
  String _schname;
  String _type;
  String _amount;
  String _year;
  String _date;
  bool _isMatured = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _schname,
      decoration: InputDecoration(labelText: 'Investemnet Scheme Name'),
      maxLength: 25,
      style: TextStyle(fontSize: 15),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Entry is Required as name';
        }

        return null;
      },
      onSaved: (String value) {
        _schname = value;
      },
    );
  }

  Widget _buildName2() {
    return TextFormField(
      initialValue: _type,
      decoration: InputDecoration(labelText: 'Investement Type'),
      maxLength: 25,
      style: TextStyle(fontSize: 15),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Entry is Required as name';
        }

        return null;
      },
      onSaved: (String value) {
        _type = value;
      },
    );
  }

  Widget _buildabc() {
    return TextFormField(
      initialValue: _amount,
      decoration: InputDecoration(labelText: 'Total Amount Invested'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 15),
      validator: (String value) {
        int amount = int.tryParse(value);

        if (amount == null || amount <= 0) {
          return 'Amount must be greater than 0 and Number';
        }

        return null;
      },
      onSaved: (String value) {
        _amount = value;
      },
    );
  }

  Widget _buildabc2() {
    return TextFormField(
      initialValue: _year,
      decoration: InputDecoration(labelText: 'Due Time Period '),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 15),
      validator: (String value) {
        int year = int.tryParse(value);

        if (year == null || year <= 0) {
          return 'year must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        _year = value;
      },
    );
  }
  Widget _buildabc4() {
    return TextFormField(
      initialValue: _date,
      decoration: InputDecoration(labelText: 'Issuing Date'),
      maxLength: 15,
      style: TextStyle(fontSize: 15),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Date Entry Required i.e 25th June,2020';
        }

        return null;
      },
      onSaved: (String value) {
        _date = value;
      },
    );
  }

  Widget _buildabc3() {
    return SwitchListTile(
      title: Text("Matured?", style: TextStyle(fontSize: 14)),
      value: _isMatured,
      onChanged: (bool newValue) => setState(() {
        _isMatured = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.inv != null) {
      _schname = widget.inv.schname;
      _type = widget.inv.type;
      _amount = widget.inv.amount;
      _year = widget.inv.year;
      _date = widget.inv.date;

      _isMatured = widget.inv.isMatured;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Investement Form")),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildName(),
              _buildName2(),
              _buildabc(),

              _buildabc2(),
              _buildabc4(),
              SizedBox(height: 2),
              _buildabc3(),
              SizedBox(height: 2),
              widget.inv == null
                  ? RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Inv inv = Inv(
                    schname: _schname,
                    type: _type,
                    amount: _amount,
                    year: _year,
                    date: _date,
                    isMatured: _isMatured,
                  );

                  DatabaseProvider.db.insert(inv).then(
                        (storedInv) => BlocProvider.of<InvBloc>(context).add(
                      AddInv(storedInv),
                    ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState.save();

                      Inv inv = Inv(
                        schname: _schname,
                        type: _type,
                        amount: _amount,
                        year: _year,
                        date: _date,
                        isMatured: _isMatured,
                      );

                      DatabaseProvider.db.update(widget.inv).then(
                            (storedInv) => BlocProvider.of<InvBloc>(context).add(
                          UpdateInv(widget.invIndex, inv),
                        ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}