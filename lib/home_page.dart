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
  late Stream<List<CustOrder>> _custOrderStream;

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
        _custOrderStream = _store
            .box<CustOrder>()
            .query()
            .watch(triggerImmediately: true)
            .map((query) => query.find());

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
        body: !hasInitialised
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder<List<CustOrder>>(
                stream: _custOrderStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return OrderTable(
                    custStore: _store,
                    custOrders: snapshot.data!,
                    onSort: (colIndex, acs) {
                      final sortQuery = _store.box<CustOrder>().query();
                      final sortField =
                          colIndex == 0 ? CustOrder_.id : CustOrder_.price;

                      sortQuery.order(sortField,
                          flags: acs ? 0 : Order.descending);

                      setState(() {
                        _custOrderStream = sortQuery
                            .watch(triggerImmediately: true)
                            .map((query) => query.find());
                      });
                    },
                  );
                }));
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
