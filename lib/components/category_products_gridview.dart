import 'package:dio/dio.dart' as Dio;
import 'package:feal_app/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:provider/provider.dart';
import 'package:feal_app/providers/cart_provider.dart';

class ExpandedProductGrid extends StatefulWidget {
  @override
  final String category_id;
  final String category_name;
  ExpandedProductGrid({this.category_id, this.category_name});
  _ExpandedProductGridState createState() => _ExpandedProductGridState();
}

class _ExpandedProductGridState extends State<ExpandedProductGrid> {
  List<Widget> productWidgets = [];
  Future<String> getProducts() async {
    var dio = Dio.Dio();
    String APIUrl = 'http://shop.galileo.ba/api/products?categoryId=' +
        this.widget.category_id.toString() +
        '&fields=name%2C%20price%2C%20localized_names%2C%20images%2C%20id%2C%20categoryId%2C%20short_description%2C%20full_description';
    dio.options.headers["Authorization"] =
        'Bearer ' + DotEnv.env['AUTHORIZATION_TOKEN'].toString();
    final response = await dio.get(APIUrl);
    productWidgets =
        getProductWidgets(response.data["products"], this.widget.category_name);
    return response.data.toString();
  }

  List getProductWidgets(value, String category_name) {
    List<Widget> newProductWidgets = [];
    for (var i = 0; i < value.length; i++) {
      newProductWidgets.add(ProductTile(
        image_location: 'images/categories/' +
            category_name.toLowerCase() +
            '/' +
            value[i]["images"][0]["id"].toString() +
            '.jpg',
        //image_location: 'images/categories/1.png',
        image_caption: value[i]["name"].toString(),
        product_id: value[i]["id"].toString(),
        category_name: this.widget.category_name,
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
    return FutureBuilder(
      future: getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              child: productWidgets.length > 0
                  ? GridView.count(
                      mainAxisSpacing: 0,
                      crossAxisCount: 1,
                      scrollDirection: Axis.vertical,
                      children: productWidgets,
                    )
                  : Text(
                      'No products found',
                      style: new TextStyle(fontSize: 20.0),
                    ),
            ),
          );
        else if (snapshot.hasError)
          return Text('An error has occurred');
        else
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }
}
// =======Products list==========

class ProductTile extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final String product_id;
  final String category_name;
  final String price;
  final String short_description;
  final String full_description;

  ProductTile(
      {this.image_location,
      this.image_caption,
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
                        product_name: this.image_caption,
                        product_id: this.product_id,
                        category_name: this.category_name,
                        price: this.price,
                        short_description: this.short_description,
                        full_description: this.full_description,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 50,
            child: ListTile(
              title: Image.asset(
                image_location,
                width: 100.0,
                height: 230.0,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    image_caption,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: new TextStyle(fontSize: 22.0, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetails extends StatefulWidget {
  final String image_location;
  final String product_name;
  final String product_id;
  String category_name = '';
  final String price;
  final String short_description;
  final String full_description;

  ProductDetails(
      {this.image_location,
      this.product_name,
      this.product_id,
      this.category_name,
      this.price,
      this.short_description,
      this.full_description});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();


}

class _ProductDetailsState extends State<ProductDetails> {
  Future<String> getCategoryName() async {
    if (widget.category_name.length == 0) {
      var dio = Dio.Dio();
      String APIUrl = 'http://shop.galileo.ba/api/categories?productId=' +
          widget.product_id +
          '&fields=name';
      dio.options.headers["Authorization"] =
          'Bearer ' + DotEnv.env['AUTHORIZATION_TOKEN'].toString();
      final response = await dio.get(APIUrl);
      widget.category_name = response.data["categories"].length > 0
          ? response.data["categories"][0]["name"].toString()
          : '';
      return response.data.toString();
    } else
      return 'categories already set';
  }

  @override
  void initState() {
    getCategoryName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WishlistProvider wishlistProvider =
        Provider.of<WishlistProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    bool _isPressed;

    return FutureBuilder(
        future: getCategoryName(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: new AppBar(
              elevation: 5,
              backgroundColor: Colors.blueGrey,
              title: Text(
                widget.category_name,
                style: new TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                ToggleIconButton(
                  initialState:
                      wishlistProvider.productList.contains(widget.product_id),
                  product_id: widget.product_id,
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  iconPressed: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
                /*IconToggleButton(
                  initialState:
                      cartProvider.productList.contains(widget.product_id),
                  product_id: widget.product_id,
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  iconPressed: Icon(
                    Icons.remove_shopping_cart,
                    color: Colors.white,
                  ),
                ),*/
              ],
            ),
            body: snapshot.hasData
                ? new Column(children: [
                    Container(
                      padding: EdgeInsets.all(13.0),
                      height: 190,
                      child:
                          Image.asset(widget.image_location, fit: BoxFit.fill),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: ExpandableText(
                        text: widget.product_name,
                        textStyle: new TextStyle(
                            fontSize: 23.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.price + ' KM',
                              style: new TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                            ),

                            Container(
                              child: Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey,width: 5),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Add to cart ',
                                        style: new TextStyle(
                                            fontSize: 22.5, color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    width:70,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[Colors.grey, Colors.blueGrey],
                                      ),
                                      borderRadius: BorderRadius.circular(4.0)
                                    ),
                                    child: Column(
                                      children: [
                                        IconToggleButton(
                                          initialState:
                                          cartProvider.productList.contains(widget.product_id),
                                          product_id: widget.product_id,
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            color: Colors.black,
                                          ),
                                          iconPressed: Icon(
                                            Icons.remove_shopping_cart,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),

                          ]),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: ExpandableText(
                        text: widget.short_description,
                        textStyle: new TextStyle(
                            fontSize: 23.0, color: Colors.black54),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child:
                            ListView(scrollDirection: Axis.vertical, children: [
                          Container(
                            padding: EdgeInsets.all(15.0),
                            child: Html(
                              data: """ """ + widget.full_description + """ """,
                              defaultTextStyle: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ])
                : snapshot.hasError
                    ? Text('An error has occurred')
                    : Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
          );
        });
  }
}

//============= EXPANDABLE TEXT ================
class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int maxLines;

  const ExpandableText({Key key, this.maxLines, this.text, this.textStyle})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Text(
          widget.text,
          style: widget.textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: _isExpanded ? 20 : widget.maxLines,
        ),
      );
}
// ================ Toggle Icon Button For Wishlist ==================

class ToggleIconButton extends StatefulWidget {
  final bool initialState;
  final String product_id;
  final Icon icon;
  final Icon iconPressed;

  ToggleIconButton(
      {this.initialState, this.product_id, this.icon, this.iconPressed});

  @override
  _ToggleIconButtonState createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  bool _isPressed;

  @override
  Widget build(BuildContext context) {
    final WishlistProvider wishlistProvider =
        Provider.of<WishlistProvider>(context);

    return InkWell(
      child: IconButton(
        icon: _isPressed ? widget.iconPressed : widget.icon,
        onPressed: () {
          setState(() {
            if (_isPressed) {
              wishlistProvider.removeItem(widget.product_id);
            } else {
              wishlistProvider.addItem(widget.product_id);
            }
            _isPressed = !_isPressed;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    _isPressed = widget.initialState;
    super.initState();
  }
}
// ================ Icon Toggle Button For Cart ==============

class IconToggleButton extends StatefulWidget {
  final bool initialState;
  final String product_id;
  final Icon icon;
  final Icon iconPressed;

  IconToggleButton(
      {this.initialState, this.product_id, this.icon, this.iconPressed});
  @override
  _IconToggleButtonState createState() => _IconToggleButtonState();
}

class _IconToggleButtonState extends State<IconToggleButton> {
  bool _isPressed;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    return InkWell(
      child: IconButton(
        icon: _isPressed ? widget.iconPressed : widget.icon,
        onPressed: () {
          setState(() {
            if (_isPressed) {
              cartProvider.removeItem(widget.product_id);
            } else {
              cartProvider.addItem(widget.product_id);
            }
            _isPressed = !_isPressed;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    _isPressed = widget.initialState;
    super.initState();
  }
}
