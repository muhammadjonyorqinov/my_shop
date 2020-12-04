import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:myshop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  );
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String userId;
  final String authToken;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders {
    return _orders;
  }


  Future<void> fetchAndSet()async{
    final url = 'https://shopapp-48c61.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    print(response.body);
    final List<OrderItem> loadedOrders = [];
    final extractedOrder = json.decode(response.body) as Map<String, dynamic>;
    if(extractedOrder == null){
      return;
    }
    extractedOrder.forEach((orderId,orderData){
      loadedOrders.add(
          OrderItem(
              orderId,
              orderData['amount'],
              (orderData['products'] as List<dynamic>).map((item)=>CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              ),).toList(),
              DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total)async {
    final url = 'https://shopapp-48c61.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response =await http.post(url,body: json.encode({
      'amount':total,
      'dateTime':timeStamp.toIso8601String(),
      'products':cartProducts.map((cartItem)=>{
        'id':cartItem.id,
        'price':cartItem.price,
        'title':cartItem.title,
        'quantity':cartItem.quantity,
      }).toList(),
    }));

    _orders.insert(
      0,
      OrderItem(
        json.decode(response.body)['name'],
        total,
        cartProducts,
        timeStamp,
      ),
    );
    notifyListeners();
  }
}
