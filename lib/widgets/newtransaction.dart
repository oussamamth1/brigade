import 'package:flutter/material.dart';
import 'dart:core';

import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx;
  NewTransaction(this.addtx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _amountcountroller = TextEditingController();

  final _titlecontroller = TextEditingController();
  DateTime _selectedDay = DateTime.now();
// void _selectedDay{
// return;}s

  SubmetData() {
    final entreAmount = double.parse(_amountcountroller.text);
    final entretitle = _titlecontroller.text;
    if (entretitle.isEmpty || entreAmount <= 0
//||
        //_selectedDay == DateTime.now().microsecond
        ) {
      return;
    } else {
      widget.addtx(entretitle, entreAmount, _selectedDay);
      Navigator.of(context).pop();
    }
  }

  void _persintdayPiker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pikerday) {
      if (pikerday == null) {
        return;
      }
      {
        setState(() {
          _selectedDay = pikerday;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedDay);
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        child: Container(
          // margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 10,
              right: 10,
              top: MediaQuery.of(context).viewInsets.top * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titlecontroller,
                // onChanged: (value) => null,
                decoration: InputDecoration(labelText: 'Title'),
                onSubmitted: (_) => SubmetData(),
              ),
              TextField(
                // onChanged: (value) => null,
                controller: _amountcountroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                onSubmitted: (_) => SubmetData(),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Text(_selectedDay == null
                        ? 'no date chossen'
                        : DateFormat.yMd().format(_selectedDay) as String),
                    Container(
                      child: TextButton(
                        child: Text('chose date '),
                        style: TextButton.styleFrom(
                          primary: Colors.teal,
                        ),
                        onPressed: _persintdayPiker,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                child: Text('Add Transaction'),
                style: TextButton.styleFrom(
                  primary: Colors.teal,
                ),
                onPressed: SubmetData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
