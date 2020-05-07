import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;
  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seus pedidos"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(17),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor, size: 80,),
            Text("Pedido realizado com sucesso!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text("Código do pedido $orderId",
              style: TextStyle(fontSize: 17,),
            ),
          ],
        ),
      ),
    );
  }
}
