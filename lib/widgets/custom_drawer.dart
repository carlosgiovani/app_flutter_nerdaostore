import 'package:appflutterlojanerdao/models/user_model.dart';
import 'package:appflutterlojanerdao/screens/login_screen.dart';
import 'package:appflutterlojanerdao/tiles/drawer_title.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        ),
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 17),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 17, 17, 8),
                height: 270,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Image.asset("assets/images/logo.png", fit: BoxFit.cover,),
                    ),
                    Positioned(
                      top: 130,
                      left: 0,
                      child: Text("Nerdao Store", style: TextStyle(fontSize: 34,
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(!model.isLoggedIn())
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => LoginScreen())
                                    );
                                  else
                                    model.signOut();
                                },
                                child: Text(!model.isLoggedIn() ? "Entre ou cadastre-se >" : "Sair",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Inicio", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
