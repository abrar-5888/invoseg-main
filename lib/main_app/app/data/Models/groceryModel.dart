class GroceryModel {
  final String id;
  final String fmName;
  final String fmPhone;
  final String fName;
  final String fPhone;
  final String status;
  final double allTotal;
  final bool count;
  final String customerAddress;
  final String customerEmail;
  final String customerName;
  final String customerPhone;
  final String pressedTime;
  final String societyName;
  final bool update;
  final List<Item> items;
  final String uid;
  final DateTime date;

  final int v;

  GroceryModel({
    required this.id,
    required this.fmName,
    required this.fmPhone,
    required this.fName,
    required this.fPhone,
    required this.status,
    required this.allTotal,
    required this.count,
    required this.customerAddress,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.pressedTime,
    required this.societyName,
    required this.update,
    required this.items,
    required this.uid,
    required this.date,
    required this.v,
  });

  factory GroceryModel.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<Item> itemsList = itemsFromJson.map((item) => Item.fromJson(item)).toList();

    return GroceryModel(
      id: json['_id'] ?? "",
      fmName: json['FMname'] ?? "",
      fmPhone: json['FMPhone'] ?? "",
      fName: json['Fname'] ?? "",
      fPhone: json['Fphone'] ?? "",
      status: json['Status'] ?? "",
      allTotal: json['allTotal'].toDouble() ?? 0.0,
      count: json['count'],
      customerAddress: json['customerAddress'] ?? "",
      customerEmail: json['customerEmail'] ?? "",
      customerName: json['customerName'] ?? "",
      customerPhone: json['customerPhone'] ?? "",
      pressedTime: json['pressedTime'] ?? "",
      societyName: json['societyName'] ?? "",
      update: json['update'] ?? "",
      items: itemsList,
      uid: json['uid'] ?? "",
      date: DateTime.parse(json['date']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FMname': fmName,
      'FMPhone': fmPhone,
      'Fname': fName,
      'Fphone': fPhone,
      'Status': status,
      'allTotal': allTotal,
      'count': count,
      'customerAddress': customerAddress,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'pressedTime': pressedTime,
      'societyName': societyName,
      'update': update,
      'items': items.map((item) => item.toJson()).toList(),
      'uid': uid,
      'date': date.toIso8601String(),
      '__v': v,
    };
  }
}

class Item {
  final String currency;
  final int quantity;
  final double price;
  final String itemName;
  final double total;
  final String id;

  Item({
    required this.currency,
    required this.quantity,
    required this.price,
    required this.itemName,
    required this.total,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      currency: json['currency'] ?? "",
      quantity: json['quantity'] ?? "",
      price: json['price'].toDouble() ?? 0.0,
      itemName: json['itemName'] ?? "",
      total: json['total'].toDouble() ?? 0.0,
      id: json['_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'quantity': quantity,
      'price': price,
      'itemName': itemName,
      'total': total,
      '_id': id,
    };
  }
}
