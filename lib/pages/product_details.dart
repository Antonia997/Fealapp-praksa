import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feal_app/main.dart';
import 'package:feal_app/pages/cart.dart';
import 'package:feal_app/pages/wishlist.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_new_price;
  final product_detail_old_price;
  final product_detail_picture;
//kontruktor
  ProductDetails(
      {this.product_detail_name,
      this.product_detail_new_price,
      this.product_detail_old_price,
      this.product_detail_picture});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}
var scaffoldKeyy=GlobalKey<ScaffoldState>();

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blueGrey,
        title: InkWell(
          //vraćanje unazad na galileu
          onTap:(){Navigator.push(context,MaterialPageRoute(builder:(context)=>new HomePage()));},
            child: Row(
              children: [
                Image.asset('images/Logo2.png',width: 130,height: 70,)
              ],
            ),),

        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>new Wishlist()));
              }),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>new Cart()));
                },
              )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                          child: new Text("KM${widget.product_detail_old_price}",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            decoration: TextDecoration.lineThrough),
                      )),
                      Expanded(
                          child: new Text("KM${widget.product_detail_new_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ======= the first buttons ======
          Row(
            children: <Widget>[
              // ======== the size bottom =====
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Size"),
                            content: new Text("Choose the size"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Size")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),

              // ======== the size bottom =====
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Colors"),
                            content: new Text("Choose a color"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Color")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),

              // ======== the size bottom =====
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Quantity"),
                            content: new Text("Choose the quantity"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Qty")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ======= the second buttons ======
          Row(
            children: <Widget>[
              // ======== the size bottom =====
              Expanded(
                child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text("Buy now")),
              ),

              new IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>new Wishlist()));
                  }),
            ],
          ),

          Divider(),
          new ListTile(
            title: new Text("Product details"),
            subtitle: new Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset "),
          ),
          Divider(),
        new Row(
          children:<Widget> [
            Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0,5.0),
            child: new Text("Product name",style: TextStyle(color:Colors.grey),),),
            Padding(padding: EdgeInsets.all(5.0),
            child: new Text(widget.product_detail_name),)
          ],
        ),
          new Row(
            children:<Widget> [
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0,5.0),
                child: new Text("Product brand",style: TextStyle(color:Colors.grey),),),

              //REMEMBER TO CREATE THE PRODUCT BRAND
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text("Brand X"),)
            ],
          ),

          // ADD THE PRODUCT CONDITION
          new Row(
            children:<Widget> [
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0,5.0),
                child: new Text("Product condition",style: TextStyle(color:Colors.grey),),),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text("NEW"),)
            ],
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar products"),
          ),
//           SIMILAR PRODUCTS SECTION
        Container(
          height: 340.0,
          child: Similar_products(),
        )
        ],
      ),
    );
  }
}

class Similar_products extends StatefulWidget {
  @override
  _Similar_productsState createState() => _Similar_productsState();
}

class _Similar_productsState extends State<Similar_products> {


  var product_list = [
    {
      "name": " T-Shirt",
      "picture": "images/products/majica.jpeg",
      "old_price": 29.38,
      "price": 23.51,
    },
    {
      "name": " Belt ",
      "picture": "images/products/kaiš.jpeg",
      "old_price": 88.15,
      "price": 70.52,
    },
    {
      "name": "Shoes",
      "picture": "images/products/tene.jpeg",
      "old_price": 53.98,
      "price": 43.19,
    },
    {
      "name": "Bosch GSB ",
      "picture": "images/products/bosch.jpeg",
      "old_price": 600,
      "price": 552.38,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Similar_single_prod(
            prod_name: product_list[index]['name'],
            prod_pricture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          );
        });
  }
}

class Similar_single_prod extends StatelessWidget {
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;

  Similar_single_prod({
    this.prod_name,
    this.prod_pricture,
    this.prod_old_price,
    this.prod_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                //here we are passing the values of the product to the product details page
                  builder: (context) => new ProductDetails(
                    product_detail_name: prod_name,
                    product_detail_new_price: prod_price,
                    product_detail_old_price: prod_old_price,
                    product_detail_picture: prod_pricture,
                  ))),
              child: GridTile(
                  footer: Container(
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(prod_name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),)
                        ),
                        new Text("KM${prod_price}",style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold),)
                      ],
                    ),
                  ),
                  child: Image.asset(
                    prod_pricture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}

