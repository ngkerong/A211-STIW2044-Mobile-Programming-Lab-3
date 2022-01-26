import 'package:com_271063_lab3/view/deleteproductpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'addproductpage.dart';
import 'package:com_271063_lab3/model/config.dart';
import 'package:com_271063_lab3/view/updateproductpage.dart';
import 'package:com_271063_lab3/model/product.dart';


class MainPage extends StatefulWidget {

  const MainPage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List _productList = [];
  String textCenter = "Loading...";
  late double screenHeight, screenWidth;
  late ScrollController _scrollController;
  int scrollcount = 6;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
    IconButton(
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductPage(
              title:"New Product")));
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeleteProductPage(
              title:"Select Product to Delete")));
      },
    ),
  ],
      ),
      body:  _productList.isEmpty
            ? Center(
                child: Text(textCenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
      
      : RefreshIndicator(
        onRefresh: _loadProducts ,
        child:  Column(children: [
         _productList == null ?  const Flexible(
          child: Center(child: Text("No Data")),):
             Flexible(
               child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      controller:_scrollController,
                      childAspectRatio: ((screenWidth / screenHeight * 1.5)),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    children: List.generate(scrollcount, (index){
              return InkWell(
                child: Container(
                child: Column(
                  children:[
                      const SizedBox(height:10),
                      CachedNetworkImage(
                            height: 120,
                            width: 120,
                            imageUrl: Config.server + "/annburger/images/products/" + _productList[index]["prid"] + ".png",
                ),const SizedBox(height:10),
                      Text( _productList[index]["prname"] + "\n" + 
                            "Price : " + "RM " + double.parse(_productList[index]["prprice"]).toStringAsFixed(2) + "\n",
                            
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                ]),
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(15)),
                ),
                  onTap: () =>{productDetails(index)} ,
              );
            }),
             ),

               )))]
        ),
      ),
      );  
  }
  Future<void> _loadProducts() async {
    var url = Uri.parse(Config.server + "/annburger/php/loadproduct.php");
    var response = await http.get(url);
    var rescode = response.statusCode;
    if(rescode == 200){
      setState(() {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      _productList = parsedJson['data']['products'];
      textCenter = "Contain Data";
      if (scrollcount >= _productList.length) {
            scrollcount = _productList.length;
          }
      }
      );
        print(_productList);
      } else {
        textCenter = "No data";
        return;
      } 
  }
   _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (_productList.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= _productList.length) {
            scrollcount = _productList.length;
          }
        }
      });
    }
   }
   productDetails(int index) {
    Product product = Product(
        prid:_productList[index]["prid"],
        prname:_productList[index]["prname"],
        prprice:_productList[index]["prprice"],
        prdesc:_productList[index]["prdesc"],);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateProductPage(
                  product:product,
                )));
  }
}