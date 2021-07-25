import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_object_box/entities.dart';
import 'package:flutter_with_object_box/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'order_data.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fakerData = Faker();
  late Store _store;
  bool hasInitialised = false;

  late CustomerData _customerData;

  @override
  void initState() {
    super.initState();
    setNewCustomer();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path, 'objectbox'),
      );

      setState(() {
        hasInitialised = true;
      });
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: setNewCustomer,
              icon: Icon(Icons.person_add_alt),
            ),
            IconButton(
              onPressed: addFakeOrderForCustomer,
              icon: Icon(Icons.attach_money),
            ),
          ],
        ),
        body: OrderTable(
          onSort: (colIndex, acs) {
            //TODO: query the database and sort
          },
        ));
  }

  void setNewCustomer() {
    _customerData = CustomerData(name: fakerData.person.name());
  }

  void addFakeOrderForCustomer() {
    final custOrder =
        CustOrder(price: fakerData.randomGenerator.integer(500, min: 10));

    custOrder.customer.target = _customerData;
    _store.box<CustOrder>().put(custOrder);
  }
}
