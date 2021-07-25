import 'package:flutter/material.dart';
import 'package:flutter_with_object_box/entities.dart';
import 'package:flutter_with_object_box/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class OrderTable extends StatefulWidget {
  final List<CustOrder> custOrders;
  final void Function(int colIndex, bool acs) onSort;
  final Store custStore;
  const OrderTable(
      {Key? key,
      required this.onSort,
      required this.custOrders,
      required this.custStore})
      : super(key: key);

  @override
  _OrderTableState createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  bool _sortAsc = true;
  int _sortColIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _sortColIndex,
          sortAscending: _sortAsc,
          columns: [
            DataColumn(
              label: Text('ID'),
              onSort: _onDataColSort,
            ),
            DataColumn(
              label: Text('Customer'),
            ),
            DataColumn(
              label: Text('Price'),
              onSort: _onDataColSort,
            ),
            DataColumn(
              label: Container(),
            ),
          ],
          rows: widget.custOrders.map(
            (order) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(order.id.toString()),
                  ),
                  DataCell(
                    Text(order.customer.target?.name ?? 'NONE'),
                    onTap: () {
                      //TODO: show order for this customer
                    },
                  ),
                  DataCell(
                    Text('\$${order.price}'),
                  ),
                  DataCell(
                    Icon(Icons.delete),
                    onTap: () {
                      widget.custStore.box<CustOrder>().remove(order.id);
                    },
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  void _onDataColSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColIndex = columnIndex;
      _sortAsc = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}
