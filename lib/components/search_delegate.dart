import 'package:flutter/material.dart';

import 'category_products_gridview.dart';

class ProductSearch extends SearchDelegate {
  final allProducts;
  final recentProducts;

  ProductSearch({this.allProducts, this.recentProducts});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList =
        query.isEmpty ? recentProducts : generateNameImageIdList(allProducts);

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Image.asset(
          "images/categories/all products/" +
              suggestionList[index].split(":")[1].toString() +
              ".jpg",
          fit: BoxFit.fitHeight,
          width: 50,
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey,
            ),
            children: highlightOccurrences(
                suggestionList[index].split(":")[0], query),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => selectedProduct(
                  suggestionList[index].split(":")[2].toString()),
            ),
          );
        },
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        query.isEmpty ? recentProducts : generateNameImageIdList(allProducts);

    return ListView.builder(
      itemBuilder: (context, index) => suggestionList.length > 0
          ? ListTile(
              leading: Image.asset(
                "images/categories/all products/" +
                    suggestionList[index].split(":")[1].toString() +
                    ".jpg",
                fit: BoxFit.fitHeight,
                width: 50,
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  children: highlightOccurrences(
                      suggestionList[index].split(":")[0], query),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => selectedProduct(
                        suggestionList[index].split(":")[2].toString()),
                  ),
                );
              },
            )
          : Text('No results'),
      itemCount: suggestionList.length,
    );
  }

  List<String> generateNameImageIdList(allProducts) {
    List<String> nameImageIdList = [];
    for (int i = 0; i < allProducts.length; i++) {
      nameImageIdList.add(allProducts[i]["name"].toString() +
          ':' +
          allProducts[i]["images"][0]["id"].toString() +
          ':' +
          allProducts[i]["id"].toString());
    }
    List<String> sortedList = nameImageIdList
        .where((product) =>
            product.split(":")[0].toLowerCase().contains(query.toLowerCase()))
        .toList();
    sortedList.sort((a, b) => b.compareTo(a));
    sortedList.sort((a, b) =>
        a.toLowerCase().indexOf(query.toLowerCase()) -
        b.toLowerCase().indexOf(query.toLowerCase()));
    return sortedList;
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
      } else if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));

        children.add(TextSpan(
          text: source.substring(match.start, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, source.length),
      ));
    }

    return children;
  }

  ProductDetails selectedProduct(product_id) {
    var product;
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i]["id"].toString() == product_id) {
        product = allProducts[i];
        break;
      }
    }
    return ProductDetails(
      image_location: 'images/categories/all products/' +
          product["images"][0]["id"].toString() +
          '.jpg',
      product_name: product["name"].toString(),
      category_name: '',
      product_id: product["id"].toString(),
      price: product["price"].toString(),
      short_description: product["short_description"].toString(),
      full_description: product["full_description"].toString(),
    );
  }
}
