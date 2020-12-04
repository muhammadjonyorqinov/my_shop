import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{

  final String  id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false});

  void setFavValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token,String userId)async{
    final url = 'https://shopapp-48c61.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try{
    final response = await http.put(url,body:json.encode(
      isFavorite
    ));
    if(response.statusCode >=400){
      setFavValue(oldStatus);
    }
    }catch(error){
       setFavValue(oldStatus);
    }
  }
}