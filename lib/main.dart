import 'package:dio/dio.dart' as Dio;
import 'package:feal_app/models/user.dart';
import 'package:feal_app/models/wrapper.dart';
import 'package:feal_app/pages/category_products.dart';
import 'package:feal_app/pages/login.dart';
import 'package:feal_app/pages/register.dart';
import 'package:feal_app/providers/wishlist_provider.dart';
import 'package:feal_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:feal_app/components/search_delegate.dart';

//my Own imports
import 'package:feal_app/components/products.dart.';
import 'package:feal_app/pages/cart.dart';
import 'package:feal_app/pages/wishlist.dart';
import 'package:feal_app/pages/categories.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:provider/provider.dart';
import 'package:feal_app/pages/login.dart';
import 'package:feal_app/pages/loginscreen.dart';
import 'package:feal_app/pages/sign_in.dart';
import 'package:feal_app/models/authentication.dart';
import 'package:feal_app/services/auth.dart';

import 'pages/cart.dart';
import 'providers/cart_provider.dart';

Future main() async {
  await DotEnv.load();
  runApp(GalileoApp());
}

class GalileoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WishlistProvider>.value(
            value: WishlistProvider()),
        ChangeNotifierProvider<CartProvider>.value(
            value: CartProvider()),
        //ChangeNotifierProvider.value(
          //  value: Authentication()),
        StreamProvider<User>.value(
            value: AuthService().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes:{
        //  Register.routeName: (ctx)=> Register(),
          //LoginPage.routeName: (ctx)=> LoginPage(),
          HomePage.routeName: (ctx)=> HomePage(),


        } ,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final AuthService _auth = AuthService();

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

  @override
  void initState() {
    getAllProducts();
    getCategories().then((value) {
      //print(value.length.toString() + ' categories');
    });
    super.initState();
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
  Widget build(BuildContext context) {
    final WishlistProvider wishlistProvider =
        Provider.of<WishlistProvider>(context);
    final CartProvider cartProvider =
    Provider.of<CartProvider>(context);
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/z1.jpeg'),
          AssetImage('images/z2.jpeg'),
          AssetImage('images/z3.jpeg'),
        ],
        autoplay: true,
        //animationCurve: Curves.fastOutSlowIn,
        //animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );

    return FutureBuilder(
      future: getAllProducts(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[200],
          appBar: new AppBar(
            elevation: 20,
            backgroundColor: Colors.blueGrey,
            title: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'images/Logo2.png',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () async{
                    //await _auth.signOut();
                    showDialog(
                        context: context,
                        builder: (context) {
                          // =================== LOG IN ================
                          return new AlertDialog(
                            actions: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        child: FlatButton(
                                            splashColor: Colors.blueGrey,
                                            onPressed: () {
                                             /* Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          new Register()));*/
                                            },
                                            child: Text(
                                              'Profile   ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            )),
                                        decoration:BoxDecoration(

                                            gradient: LinearGradient(
                                                colors: <Color>[
                                              Colors.grey,
                                              Colors.blueGrey
                                            ])),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        child: FlatButton(
                                            splashColor: Colors.blueGrey,
                                            onPressed: () async{
                                              await _auth.signOut();
                                            },
                                            child: Text(
                                              'Log Out  ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            )),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: <Color>[
                                              Colors.grey,
                                              Colors.blueGrey
                                            ])),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            elevation: 20.0,
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                          );
                        });
                  }),
              new IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Wishlist(
                                  product_ids: wishlistProvider.productList,
                                )));
                  }),
              new IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new Cart(
                              product_ids: cartProvider.productList,
                            )));
                  }),
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
          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: <Color>[Colors.grey, Colors.blueGrey])),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            elevation: 20,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/Logo2.png',
                                width: 80.0,
                                height: 80.0,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Galileo',
                            style:
                                TextStyle(color: Colors.white, fontSize: 21.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //header
                /*new UserAccountsDrawerHeader(
              accountName: Text('Antonia Pinjuh'),
              accountEmail: Text('antonia.pinjuh@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.blueGrey),
            ),*/

                //body

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new HomePage()));
                    },
                    child: ListTile(
                      title: Text('Home Page'),
                      leading: Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {},
                    child: ListTile(
                      title: Text('My Account'),
                      leading: Icon(Icons.person, color: Colors.black),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {},
                    child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(Icons.shopping_basket, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Categories()));
                    },
                    child: ListTile(
                      title: Text('Category'),
                      leading: Icon(Icons.category, color: Colors.black),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new Cart(
                            product_ids: cartProvider.productList,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Shopping cart'),
                      leading: Icon(Icons.shopping_cart, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new Wishlist(
                            product_ids: wishlistProvider.productList,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Favourite'),
                      leading: Icon(Icons.favorite, color: Colors.black),
                    ),
                  ),
                ),

                Divider(),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {},
                    child: ListTile(
                      title: Text('Settings'),
                      leading: Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                Container(
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {},
                    child: ListTile(
                      title: Text('About'),
                      leading: Icon(
                        Icons.help,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========== BODY =======
          body:new Column(
        children: <Widget>[

        //===================image carousel begin here=================
        image_carousel,
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             decoration: BoxDecoration(
                 color: Colors.blueGrey,
                 borderRadius: BorderRadius.circular(10.0)),
             child: Row(
               children: <Widget>[
                 new Padding(
                   padding: const EdgeInsets.all(14.0),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.blueGrey
                     ),
                     alignment: Alignment.center,
                     child: new Text(
                       'Category',
                       style: new TextStyle(
                         color: Colors.white,
                         fontSize: 22.0,
                         fontWeight: FontWeight.bold,
                       ),
                       //textAlign: TextAlign.center,
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),

        Expanded(child: ListView(
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
        ),)

        //padding widget
        /*new Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: new Text(
                'Category',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),*/

        /* ===========moja horizontalna lista =======
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (_ ,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:<Widget> [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[400],
                                    offset: Offset(4,6),
                                    blurRadius: 20
                                )
                              ]
                          ),
                          child: Padding(padding: EdgeInsets.all(4),
                            child: Image.asset("images/cats/tools.png",width: 50,),


                          ),


                      ),
                      SizedBox(height: 5,),
                      new Text("Tools",style: new TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)

                    ],
                  ),
                );
              },
            ),
          ),*/

        //========Horizontal list view begins here==========
        //     HorizontalList(),
//padding widget
       /* Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
        decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10.0)),
        child: Row(
        children: <Widget>[
        new Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
        alignment: Alignment.center,
        child: new Text(
        'Recent products',
        style: new TextStyle(
        color: Colors.white,
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        ),
        //textAlign: TextAlign.center,
        ),
        ),
        ),
        ],
        ),

        ),
        ),*/

//grid view
        ],
        ),

        );
      },
    );
  }
}
