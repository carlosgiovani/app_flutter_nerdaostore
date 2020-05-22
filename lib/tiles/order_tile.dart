import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderId;
  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("orders").document(orderId).snapshots(),
          // ignore: missing_return
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Código do pedido: ${snapshot.data.documentID}",
                  ),
                  SizedBox(height: 5,),
                  Text(
                    _buildProductsText(snapshot.data),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descrição:\n";
    for(LinkedHashMap p in snapshot.data["products"]){
      text += "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }
}
