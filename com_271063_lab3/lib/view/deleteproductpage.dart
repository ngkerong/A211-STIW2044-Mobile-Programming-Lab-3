import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'addproductpage.dart';
import 'package:com_271063_lab3/model/config.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DeleteProductPage extends StatefulWidget {

  const DeleteProductPage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  late List _productList = [];
  String textCenter = "Loading...";
  late double screenHeight, screenWidth;


  @override
  void initState() {
    super.initState();
    
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

      ),
      body:  RefreshIndicator(
        onRefresh: _loadProducts,
        child:  Column(children: [
         _productList == null ?  const Flexible(
          child: Center(child: Text("No Data")),):
             Flexible(
               child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: ((screenWidth / screenHeight)*1.5),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                    itemCount: _productList.length,
                    itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                child: Container(
                child: Column(children:[
                      const SizedBox(height:10),
                      CachedNetworkImage(
                            height: 120,
                            width: 120,
                            imageUrl: Config.server + "/annburger/images/products/${_productList[index]["prid"]}.png",
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
                  onTap: () =>{_onDeletePr(index)} ,
              );
            }),
             ),

               ))]
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
      }
      );
        print(_productList);
      } else {
        textCenter = "No data";
        return;
      } 
  }

    _onDeletePr(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete this product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
   _deleteProduct(int index) {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Deleting product.."),
        title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse(Config.server + "/annburger/php/deleteproduct.php"),
        body: {
          "prid": _productList[index]['prid'],
          
        }).then((response) {
      var data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  } 
}