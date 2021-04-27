import 'package:flutter/material.dart';
import 'package:feal_app/pages/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
      "name": "MAKITA",
      "picture": "images/products/makita.png",
      "old_price": 546.51,
      "price": 477.95,
    },
    {
      "name": "If You Wait",
      "picture": "images/products/cd.jpeg",
      "old_price": 10,
      "price": 5.48,
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
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Single_prod(
              prod_name: product_list[index]['name'],
              prod_pricture: product_list[index]['picture'],
              prod_old_price: product_list[index]['old_price'],
              prod_price: product_list[index]['price'],
            ),
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_pricture;
  final prod_old_price;
  final prod_price;

  Single_prod({
    this.prod_name,
    this.prod_pricture,
    this.prod_old_price,
    this.prod_price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    color: Colors.white70,
                    child: ListTile(
                      title: Text(
                        prod_name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "KM$prod_price",
                        style: TextStyle(
                          color: Colors.black,fontSize: 18,fontWeight: FontWeight.w800
                        ),
                      ),
                      // ======== OLD PRICE =======
                    /*  subtitle: Text(
                        "KM$prod_old_price",
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w800, decoration: TextDecoration.lineThrough
                        ),
                      ),*/

                    ),
                  ),
                  child: Image.asset(
                    prod_pricture,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
    );
  }
}
