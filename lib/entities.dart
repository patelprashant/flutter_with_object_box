import 'package:objectbox/objectbox.dart';

@Entity()
class CustOrder {
  int id;
  int price;

  final customer = ToOne<CustomerData>();

  CustOrder({
    this.id = 0,
    required this.price,
  });
}

@Entity()
class CustomerData {
  int id;
  String name;

  @Backlink()
  final myOrders = ToMany<CustOrder>();

  CustomerData({
    this.id = 0,
    required this.name,
  });
}
