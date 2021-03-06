import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final productId = this.id;
    final url =
        'https://shop-app-19479.firebaseio.com/userFavorites/$userId/$productId.json?auth=$token';
    var existingStatus = this.isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      this.isFavorite = existingStatus;
      notifyListeners();
      throw HttpException('Could not update Favorite Status');
    }
    existingStatus = null;
  }
}
