import 'package:feal_app/components/category_products_gridview.dart';
import 'package:feal_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;


class Cart extends StatefulWidget {
  List<String> product_ids = [];
  Cart({this.product_ids});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Widget> productWidgets = [];

  Future<String> getProducts() async {
    if (widget.product_ids.isNotEmpty) {
      var dio = Dio.Dio();
      String ids_parameter = '';
      for (var i = 0; i < widget.product_ids.length; i++) {
        ids_parameter += 'ids=' + widget.product_ids[i] + '&';
      }
      String APIUrl = 'http://shop.galileo.ba/api/products?' +
          ids_parameter +
          'fields=name%2C%20price%2C%20localized_names%2C%20images%2C%20id%2C%20categoryId%2C%20short_description%2C%20full_description';
      dio.options.headers["Authorization"] =
          'Bearer ' + DotEnv.env['AUTHORIZATION_TOKEN'].toString();
      final response = await dio.get(APIUrl);
      productWidgets = getProductWidgets(response.data["products"]);
      return response.data.toString();
    }
    return 'no products';
  }
  List getProductWidgets(value) {
    List<Widget> newProductWidgets = [];
    for (var i = 0; i < value.length; i++) {
      newProductWidgets.add(CartTile(
        image_location: 'images/categories/all products/' +
            value[i]["images"][0]["id"].toString() +
            '.jpg',
        //image_location: 'images/categories/1.png',
        product_name: value[i]["name"].toString(),
        product_id: value[i]["id"].toString(),
        price: value[i]["price"].toString(),
        short_description: value[i]["short_description"] != null
            ? value[i]["short_description"].toString()
            : '',
        full_description: value[i]["full_description"] != null
            ? value[i]["full_description"].toString()
            : '',
      ));
    }
    return newProductWidgets;
  }
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider =
    Provider.of<CartProvider>(context);

    return FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: new AppBar(
              elevation: 0.1,
              backgroundColor: Colors.blueGrey,
              title: Text(
                'Cart',
                style: new TextStyle(color: Colors.white),
              ),
            ),
            body: //new Cart_products(),
            Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.hasData
                    ? (productWidgets.length > 0
                    ? productWidgets
                    : [
                  Text('Cart empty'),
                ])
                    : snapshot.hasError
                    ? [
                  Text('An error has occurred'),
                ]
                    : [
                  Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
class CartTile extends StatelessWidget {
  final String image_location;
  final String product_name;
  final String product_id;
  final String category_name;
  final String price;
  final String short_description;
  final String full_description;

  CartTile(
      {this.image_location,
        this.product_name,
        this.product_id,
        this.category_name,
        this.price,
        this.short_description,
        this.full_description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new ProductDetails(
                image_location: this.image_location,
                product_name: this.product_name,
                product_id: this.product_id,
                category_name: '',
                price: this.price,
                short_description: this.short_description,
                full_description: this.full_description,
              ),
            ),
          );
        },
        child: Container(
          height: 90,
          child: Row(
            children: [
              Image.asset(
                this.image_location,
                fit: BoxFit.fitHeight,
                width: 90,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    this.product_name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
