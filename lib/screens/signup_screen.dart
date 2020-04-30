import 'package:appflutterlojanerdao/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(38),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Nome completo",
                ),
                validator: (text) {
                  if (text.isEmpty) return "Nome inválido.";
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "E-mail inválido.";
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty || text.length < 6) return "Senha inválida.";
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Endereço",
                ),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty) return "Endereço inválida.";
                },
              ),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  child: Text(
                    "Criar conta",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Map<String, dynamic> userData = {
                        "name": _nameController.text,
                        "email": _emailController.text,
                        "address": _addressController.text
                      };
                      model.signUp(
                        userData: userData,
                          pass: null,
                          onSuccess: null,
                          onFail: null);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuario criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuario!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ),);
  }
}
