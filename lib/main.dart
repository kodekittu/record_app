import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';
import './widgets/transaction_list.dart';

void main (){
  // for making only for portrait mode
 // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

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

  bool _showChart = false;

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

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
          middle: Text('Daily record',style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            GestureDetector(
              onTap: () => _startAddNewTransaction(context),
              child: Icon(CupertinoIcons.add),
            ),
          ],),
        )
        : AppBar(
           title: Text('Daily record',style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),),
          actions: <Widget>[IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),)
      ],
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody = SafeArea(child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ignore: sdk_version_ui_as_code
          if (isLandscape) Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show Chart',style: Theme.of(context).textTheme.title,),
              Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, onChanged: (val) {
                setState(() {
                  _showChart =  val;
                });
              })
            ],
          ),
          if(!isLandscape)  Container(
              height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
              child: Chart(_recentTransactions)),
          if(!isLandscape) txListWidget,
          if (isLandscape) _showChart ? Container(
              height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
              child: Chart(_recentTransactions))
              : txListWidget,
        ],
      ),
    ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar,)
        : Scaffold(
          appBar: appBar,
          body: pageBody,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Platform.isIOS ? Container()
          :FloatingActionButton(child: Icon(Icons.add),onPressed: () => _startAddNewTransaction(context),),
    );
  }
}