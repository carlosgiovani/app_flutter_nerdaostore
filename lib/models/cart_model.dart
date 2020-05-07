import 'package:appflutterlojanerdao/datas/cart_product.dart';
import 'package:appflutterlojanerdao/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItems();
  }

  // p/ acessar de qualquer lugar
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
    
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();
    products.remove(cartProduct);
    notifyListeners();
  }
  // remover produtos do carrinho
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
      .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  // add mais quantidade do produto no carrinho
  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  // pegar todos os prod. do carrinho no banco
  void _loadCartItems() async{
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  //aplica desconto ao carrinho
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  // funcoes dos valores no carrinho
  // retorna subtotal
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }

  // retorna valor da entrega
  double getShipPrice(){
    return 9.99;
  }

  // retorna valor do desconto
  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  // refresh nos precos para carregar os valores
  void updatePrices(){
    notifyListeners();
  }

  // salvar pedidos no banco
  Future<String> finishOrder() async{
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // salva pedido no banco
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
     {
       "clientId": user.firebaseUser.uid,
       "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
       "shipPrice": shipPrice,
       "productsPrice": productsPrice,
       "discount": discount,
       "totalPrice": productsPrice - discount + shipPrice,
       "status": 1
     }
    );
    // salva o id do pedido no usuario no banco
    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("orders").document(refOrder.documentID).setData(
      {
        "orderId": refOrder.documentID
      }
    );
    // limpando carrinho
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }
}
