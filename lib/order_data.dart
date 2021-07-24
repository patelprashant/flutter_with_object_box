import 'dart:ffi';

import 'package:flutter/material.dart';

class OrderTable extends StatefulWidget {
  final void Function(int colIndex, bool acs) onSort;
  const OrderTable({Key? key, required this.onSort}) : super(key: key);

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
              label: Text('Number'),
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
          rows: [
            DataRow(
              cells: [
                DataCell(
                  Text('ID'),
                ),
                DataCell(
                  Text('CUSTOMER NAME'),
                  onTap: () {
                    //TODO: show order for this customer
                  },
                ),
                DataCell(
                  Text('\$PRICE'),
                ),
                DataCell(
                  Icon(Icons.delete),
                  onTap: () {
                    //TODO: delete order
                  },
                ),
              ],
            )
          ],
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
