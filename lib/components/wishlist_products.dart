import 'package:flutter/material.dart';




class Wishlist_products extends StatefulWidget {
  @override
  _Wishlist_productsState createState() => _Wishlist_productsState();
}

class _Wishlist_productsState extends State<Wishlist_products> {
  var Products_on_the_wishlist = [
    {
      "name": " T-Shirt",
      "picture": "images/products/majica.jpeg",
      "price": 23.51,
      "size": "M",
      "color": "Black",
      "quantity": 1,
    },
    {
      "name": "Shoes",
      "picture": "images/products/tene.jpeg",
      "price": 43.19,
      "size": "39",
      "color": "Red",
      "quantity": 1,
    },
    {
      "name": " Belt ",
      "picture": "images/products/kaiš.jpeg",
      "price": 70.52,
      "size": "L",
      "color": "Blue",
      "quantity": 1,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: Products_on_the_wishlist.length,
        itemBuilder: (context, index) {
          return Single_wishlist_product(
            wishlist_prod_name: Products_on_the_wishlist[index]["name"],
            wishlist_prod_color: Products_on_the_wishlist[index]["color"],
            wishlist_prod_qty: Products_on_the_wishlist[index]["quantity"],
            wishlist_prod_size: Products_on_the_wishlist[index]["size"],
            wishlist_prod_price: Products_on_the_wishlist[index]["price"],
            wishlist_prod_pricture: Products_on_the_wishlist[index]["picture"],
          );
        });
  }
}
class Single_wishlist_product extends StatelessWidget {
  final wishlist_prod_name;
  final wishlist_prod_pricture;
  final wishlist_prod_price;
  final wishlist_prod_size;
  final wishlist_prod_color;
  final wishlist_prod_qty;

  Single_wishlist_product(
      {this.wishlist_prod_name,
        this.wishlist_prod_pricture,
        this.wishlist_prod_color,
        this.wishlist_prod_price,
        this.wishlist_prod_qty,
        this.wishlist_prod_size});
  @override
  Widget build(BuildContext context) {
    return Card(
         child: ListTile(
        // ===== LEADING SECTION ==============
            leading: new Image.asset(wishlist_prod_pricture,width: 80.0,
              height: 80.0,),

            // ========== TITLE SECTION ===========
            title: new Text(wishlist_prod_name),

            // ======== SUBTITLE SECTION ===========
            subtitle: new Column(
              children: <Widget>[
                // =======ROW INSIDE THE COLUMN ===

                new Row(
                  children: <Widget>[
                    // this section if for the size of the product
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Text("Size:"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(
                        wishlist_prod_size,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    //  ====== This section is for the product color =======

                    new Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                      child: new Text("Color:"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(wishlist_prod_color,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                // ======THIS SECTION IS FOR THE PRODUCT PRICE
                new Container(
                  alignment: Alignment.topLeft,
                  child: new Text(
                    "KM ${wishlist_prod_price}",
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                )
              ],
            ),
        ) ,

      );

  }
}


