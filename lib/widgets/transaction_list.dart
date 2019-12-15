import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty  ?
    LayoutBuilder(builder: (ctx , constraints){
      return Column(children: <Widget>[
        Text('No transaction yet!!', style: Theme.of(context).textTheme.title,),
        SizedBox(height: 15,),
        Container(
            height: constraints.maxHeight * .6,
            child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,)),
      ],
      );
       })
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {  // **** Card ****//
          return Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(leading:
                CircleAvatar(radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(child:
                  Text('₹'+transactions[index].amount.toStringAsFixed(2),
                  ),
                  ),
                ),
                  ),
              title: Text(transactions[index].title ,
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)
              ),
              subtitle: Text(DateFormat(/*'dd-MM-yyyy'*/).format(transactions[index].date),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.bold),
              ),
              trailing: MediaQuery.of(context).size.width > 450 ?
                  FlatButton.icon(
                    onPressed: () => deleteTx(transactions[index].id),
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    textColor: Theme.of(context).errorColor,
                  )
                  : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteTx(transactions[index].id),
                color: Theme.of(context).errorColor,
              ),
            ),
          );
        },
    );
  }
}

// **** Card ****//

/*Card(
            elevation: 5,
            margin: EdgeInsets.all(6),
            child: Row(children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Text('₹'+transactions[index].amount.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 2, style: BorderStyle.solid,)),
                padding: EdgeInsets.all(10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(transactions[index].title ,style: TextStyle(color: Colors.deepPurple, fontSize: 18,fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(DateFormat(/*'dd-MM-yyyy'*/).format(transactions[index].date),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
            ),
          )*/