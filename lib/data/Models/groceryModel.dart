// ignore_for_file: file_names

class GroceryModel {
  final List<ItemsModel> items;
  final String status;
  final int allTotal;
  final String customerAddress;
  final String customerEmail;
  final String customerName;
  final String customerPhone;
  final int timestamp;
  final String societyName;
  final String time;
  final bool update;

  GroceryModel({
    required this.items,
    required this.status,
    required this.allTotal,
    required this.customerAddress,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.timestamp,
    required this.societyName,
    required this.time,
    required this.update,
  });

  factory GroceryModel.fromJson(Map<String, dynamic> data) {
    return GroceryModel(
      items: (data['items'] as List<dynamic>)
          .map((item) => ItemsModel.fromJson(item))
          .toList(),
      status: data['Status'] ?? '',
      allTotal: data['allTotal'] ?? 0,
      customerAddress: data['customerAddress'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      timestamp: data['pressedTime'].seconds ?? 0,
      societyName: data['societyName'] ?? '',
      time: data['time'] ?? '',
      update: data['update'] ?? false,
    );
  }
}

class ItemsModel {
  final String currency;
  final String itemName;
  final int quantity;
  final int price;
  final int total;

  ItemsModel({
    required this.currency,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> data) {
    return ItemsModel(
      currency: data['currency'] ?? '',
      itemName: data['itemName'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: data['price'] ?? 0,
      total: data['total'] ?? 0,
    );
  }
}
