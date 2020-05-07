import 'package:appflutterlojanerdao/models/user_model.dart';
import 'package:appflutterlojanerdao/screens/login_screen.dart';
import 'package:appflutterlojanerdao/tiles/order_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isLoggedIn()){
      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid)
          .collection("orders").getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList(),
            );
          }
        },
      );



    } else{
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_list, size: 80, color: Theme.of(context).primaryColor,),
            SizedBox(height: 17,),
            Text("Faça o seu login para acompanhar seu pedido",
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
    }
  }
}
