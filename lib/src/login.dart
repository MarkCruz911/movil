import 'package:bus_client/src/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(Login());

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              label: const Text('Inicio de Sesion'),
              backgroundColor: Colors.grey,
              onPressed: () {
                postData();
              },
            ),
          ],
        ),
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postData() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final url =
        Uri.parse('https://biblioapidb.azurewebsites.net/api/User/Login');
    final data = {'email': email.toString(), 'password': password.toString()};
    final jsonData = jsonEncode(data);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    print('-------------------*');
    if (response.statusCode == 200) {
      // procesa la respuesta exitosa
      final responseData = jsonDecode(response.body);
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('email', email.toString());
      print(sharedPreferences.getString('email'));
      //sharedPreferences.remove('userName'); //Eliminar
      // ... hacer algo con los datos de respuesta
    } else {
      // maneja errores
      print('error-----------');
    }
  }

  /*void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    var passwordDos = "andkadnsjk";
    
    FirebaseAuth.instance.authStateChanges().listen((user){
      if(user==null) {
        print("No Paso//////77777///777/////////7777/////7777///7777777777/7/");
        MaterialPageRoute routess = MaterialPageRoute(builder: (context)=> const Login());
        Navigator.push(context, routess);
      }
    });

    CollectionReference ref = FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuario = await ref.get();
    if(usuario.docs.length !=0){
      for(var cursor in usuario.docs){
        if(cursor.get('password')==password){
          print("password encontrado");
          passwordDos = cursor.get('password');
          print(cursor.get('name'));
          if(cursor.get('email')==email){
            print('email encontrado, puedes acceder');

   print("paso");
            final credencial = FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email, 
              password: password,
            );
            final FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;
            user?.uid;
            MaterialPageRoute routess = MaterialPageRoute(builder: (context)=> const Home());
            Navigator.push(context, routess);         
          }
        }
      }
    }else{
      print('No hay documentos en la coleccion');
    }

  if (usuario == null) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('El usuario no existe'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
    return;
  }
  
  if (password != passwordDos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('La contraseña es incorrecta'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
    return;
  }

}*/

}
