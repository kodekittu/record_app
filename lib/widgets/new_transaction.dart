import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData(){
    final enteredTitle= _titleController.text;
    final enteredAmount=double.parse( _amountController.text);

    if(_amountController.text.isEmpty){
      return;
    }
    if(enteredTitle.isEmpty||enteredAmount<=0 || _selectedDate==null){
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    
    Navigator.of(context).pop();  // or automatically closing the sheet when done
  }

  void _presentDatePicker(){
    showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
    ).then((pickedDate){
          if(pickedDate ==null) {
            return;
          }
          setState(() {
            _selectedDate = pickedDate ;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData,
              /*onChanged: (val){
                    titleInput=val;
                },*/
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData,
              /* onChanged: (val){
                    amountInput = val;
                  },*/
            ),
            Container(
              height: 45,
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(_selectedDate==null ? 'No date choosen'
                      : 'Picked date ' + DateFormat.yMd().format(_selectedDate)
                  ),
                ),
                FlatButton(
                  child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.bold)),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: _presentDatePicker,
                )
              ],),
            ),
            RaisedButton(onPressed: _submitData,
                child: Text('Add Item',style: TextStyle(fontWeight: FontWeight.bold),),
                color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
            ),
          ],
        ),
      ),
    );
  }
}
