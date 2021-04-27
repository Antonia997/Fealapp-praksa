import 'package:feal_app/components/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:feal_app/components/category_products_gridview.dart';
import 'package:dio/dio.dart' as Dio;

class CategoryProducts extends StatefulWidget {
  final String category_id;
  final String category_name;

  CategoryProducts({this.category_id, this.category_name});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  List all_products = [];
  Future<List> getAllProducts() async {
    var dio = Dio.Dio();
    String APIUrl =
        'http://shop.galileo.ba/api/products?limit=250&fields=name%2C%20price%2C%20short_description%2C%20full_description%2C%20id%2C%20images';
    dio.options.headers["Authorization"] =
        'Bearer ' + DotEnv.env['AUTHORIZATION_TOKEN'].toString();
    final response = await dio.get(APIUrl);
    all_products = response.data["products"];
    return response.data["products"];
  }

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blueGrey,
        title: Text(this.widget.category_name,style: new TextStyle(color: Colors.white),),
        actions:<Widget> [
          new IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed:(){
            showSearch(context: context, delegate: ProductSearch(allProducts: all_products, recentProducts: []));
          })
        ],
      ),


        body: new Column(
          children: <Widget>[
            ExpandedProductGrid(category_id: this.widget.category_id, category_name: this.widget.category_name,),
          ],

        ),
    );
  }
}
