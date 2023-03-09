import 'package:bus_client/src/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(Register());

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _linea = 'Linea 10';
  final activo = false;
  // ignore: unused_field
  final _rolController = TextEditingController();
  String _role = 'Chofer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
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
              DropdownButtonFormField(
                value: _role,
                onChanged: (newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Chofer',
                    child: Text('Chofer'),
                  ),
                  DropdownMenuItem(
                    value: 'Pasajero',
                    child: Text('Pasajero'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Registrar'),
              ),
              ElevatedButton(
                onPressed: (){
                  MaterialPageRoute route = MaterialPageRoute(builder: (context)=> const Login());
                  Navigator.push(context, route); 
                },
                child: Text('Ir a Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _role;
    
    print("que rol esss");
    print(role);

    if(role == 'Chofer'){
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Registrar Linea'),
        content: SingleChildScrollView(
          child: Form(child: Column(
            children: [
              DropdownButtonFormField(
                value: _linea,
                onChanged: (newValue) {
                  setState(() {
                    _linea = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Linea 10',
                    child: Text('Linea 10'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 8',
                    child: Text('Linea 8'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 5',
                    child: Text('Linea 5'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 2',
                    child: Text('Linea 2'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 16',
                    child: Text('Linea 16'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 17',
                    child: Text('Linea 17'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 18',
                    child: Text('Linea 18'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 9',
                    child: Text('Linea 9'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 1',
                    child: Text('Linea 1'),
                  ),
                  DropdownMenuItem(
                    value: 'Linea 11',
                    child: Text('Linea 11'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: (){
                  _confirm();
                Navigator.of(context).pop();
                },
                child: Text('Grabar Todo'),
              ),
            ],
          )),
        ),
      );

    }
   );
   }else{
    _confirm();
   }
   final linea = _linea; 
  
    //print('Registro completado con éxito. ID del usuario: ${document.documentID}');
    
  }
  void _confirm()async{
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _role;
    final linea = _linea; 
    if(role=='Chofer'){
    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'rol': role,
      'linea':linea,
      'activo':activo,
    };

    try{
      print("ingreso a registrar Auth");

      final UserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
      print("termino Auth");
      final a = UserCredential.user?.uid;
      
      print("aqui esta el uid");
      print (a);

      print("ingreso a registrar fire");
      final usersCollection = _firestore.collection('usuarios').doc(UserCredential.user?.uid);
      final document = await usersCollection.set(userData);

      print("termino fire");

    }catch(e){
      print("Error, no se registro correctamente a Auth");
    }

      
    

  }else{
    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'rol': role,
    };

    try{
      print("ingreso a registrar Auth");

      final UserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
      print("termino Auth");
      
      print("ingreso a registrar fire");
      final usersCollection = _firestore.collection('usuarios').doc(UserCredential.user?.uid);
      final document = await usersCollection.set(userData);

      print("termino fire");

    }catch(e){
      print("Error, no se registro correctamente a Auth");
    }

      
      
  }
  MaterialPageRoute route = MaterialPageRoute(builder: (context)=> const Login());
  Navigator.push(context, route);
  }
}
