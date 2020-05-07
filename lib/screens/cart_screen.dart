import 'package:appflutterlojanerdao/models/cart_model.dart';
import 'package:appflutterlojanerdao/models/user_model.dart';
import 'package:appflutterlojanerdao/screens/login_screen.dart';
import 'package:appflutterlojanerdao/screens/order_screen.dart';
import 'package:appflutterlojanerdao/tiles/cart_tile.dart';
import 'package:appflutterlojanerdao/widgets/cart_price.dart';
import 'package:appflutterlojanerdao/widgets/discount_card.dart';
import 'package:appflutterlojanerdao/widgets/ship_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? "item" : "itens"}"
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        // ignore: missing_return
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 80, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 17,),
                  Text("Faça o seu login para adicionar produtos ao seu carrinho",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 17,),
                  RaisedButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                    child: Text("Fazer login", style: TextStyle(fontSize: 17),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          } else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text("Seu carrinho esta vazio!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            );
          // ignore: unnecessary_statements
          } else {
            return ListView(
              children: [
                Column(
                  children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async{
                  String orderId =  await model.finishOrder();
                  if(orderId != null)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrderScreen(orderId)),
                    );
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
