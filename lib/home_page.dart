import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'order_data.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fakerData = Faker();

  @override
  void initState() {
    super.initState();
    setNewCustomer();
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
    //TODO: Implement
    print('Name:${fakerData.person.name()}');
  }

  void addFakeOrderForCustomer() {
    //TODO: Implement
    print('Price:${fakerData.randomGenerator.integer(500, min: 10)}');
  }
}
