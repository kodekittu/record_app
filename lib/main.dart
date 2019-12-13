import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';
import './widgets/transaction_list.dart';

void main ()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Record App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.bold,fontSize: 18),
          button: TextStyle(color: Colors.white)
        ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
//String titleInput;
//String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransaction = [
   /* Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),*/
  ];

  List<Transaction> get _recentTransactions{
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days:  7),),);
    }
    ).toList();
  }

  void _addNewTransaction(String title0, double amount0, DateTime chosenDate) {
    final newTx = Transaction(
      title: title0,
      amount: amount0,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState((){
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    },
    );
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily record',style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
        actions: <Widget>[
          IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Chart(_recentTransactions),
            TransactionList(_userTransaction, _deleteTransaction),
        ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () => _startAddNewTransaction(context),),
    );
  }
}