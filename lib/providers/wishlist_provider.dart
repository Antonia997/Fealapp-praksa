import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
    List<String> _productList = [];
    List<String> get productList => _productList;
    set productList(List<String> newList){
      _productList = [...newList];
      notifyListeners();
    }

    addItem (String product_id){
      productList = [...productList, product_id];
    }
    removeItem (String product_id){
      List<String> newList = [...productList];
      newList.remove(product_id);
      productList = [...newList];
    }
}