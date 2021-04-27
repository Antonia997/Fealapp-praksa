import 'dart:ui';

import 'package:dio/dio.dart' as Dio;
import 'package:feal_app/components/search_delegate.dart';
import 'package:feal_app/pages/category_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/cupertino.dart';




class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Widget> categoryWidgets = [];
  Future<List> getCategories() async {
    var dio = Dio.Dio();
    String APIUrl =
        'http://shop.galileo.ba/api/categories?fields=name%2C%20localized_name%2C%20image%2C%20id';
    dio.options.headers["Authorization"] = 'Bearer ' + DotEnv.env['AUTHORIZATION_TOKEN'].toString();
    final response = await dio.get(APIUrl);
    categoryWidgets = getCategoryWidgets(response.data["categories"]);
    return response.data["categories"];
  }
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

  List getCategoryWidgets(value) {
    List<Widget> newCategoryWidgets = [];
    for (var i = 0; i < value.length; i++) {
      newCategoryWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new CategoryProducts(
                        category_id: value[i]["id"].toString(),
                        category_name: value[i]["name"].toString())));
          },
          child: Container(
            child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(4.0),
              shadowColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 3.0, left: 20.0, right: 5.0),
                      child: Text(
                        value[i]["name"],
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 3.0, bottom: 3.0, left: 0.0, right: 15.0),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(4.0),
                      child: Image(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        image: AssetImage(
                          "images/categories/" +
                              value[i]["id"].toString() +
                              ".png",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return newCategoryWidgets;
  }

  @override
  void initState() {
    super.initState();
    getCategories().then((value) {
      //print(value.length.toString() + ' categories');
    });
    getAllProducts();


  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(),
      builder: (context, snapshot) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[200],
            appBar: new AppBar(
              elevation: 10,
              backgroundColor: Colors.blueGrey,
              title: Text(
                'Categories',
                style: new TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                new IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(context: context, delegate: ProductSearch(allProducts: all_products, recentProducts: []));

                    }),
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: snapshot.hasData
                          ? categoryWidgets
                          : snapshot.hasError
                              ? [
                                  Text('An error has occurred'),
                                ]
                              : [
                                  Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                      child: CircularProgressIndicator()
                                  )
                                ],
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }

  /*Widget myDetailsContainer(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget> [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(child: Text("Tools",
          style: TextStyle(color: Colors.black,fontSize: 24.0,fontWeight: FontWeight.bold),),),
        )
      ],

    );
  }*/
}
