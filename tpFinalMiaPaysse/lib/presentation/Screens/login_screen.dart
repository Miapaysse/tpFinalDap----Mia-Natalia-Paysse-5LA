import 'package:clase18_4/Entities/User.dart';
import 'package:clase18_4/presentation/Screens/home_screen.dart';
import 'package:clase18_4/presentation/Screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController passController = TextEditingController();
  TextEditingController userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: userController,
            decoration: const InputDecoration(
              hintText: 'Username',
              icon: Icon(Icons.person_2_outlined),
            ),
          ),
          TextField(
            controller: passController,
            decoration: const InputDecoration(
              hintText: 'Password',
              icon: Icon(Icons.lock_clock_outlined),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String inputUser = userController.text;
              String inputPass = passController.text;

              if (inputPass.isEmpty || inputUser.isEmpty) {
                print("Contraseña o User vacíos");
                const SnackBar snackBar = SnackBar(
                  content: Text(
                      "Contraseña o User vacíos, complete los campos requeridos"),
                );
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(snackBar);
              }

              final users = FirebaseFirestore.instance.collection('users'); //obtengo la coleccion

              final userDoc = await LoadingScreen.showLoadingScreen( // La loading creen hace todo mas lindo, me ayudo chat, pero lo que se es q await: no empiezo lo siguiente hasta que 
                  context, users.doc(inputUser.toLowerCase()).get()); //obtengo el documento de la coleccion con el nombre de usuario que es insensibles a mayusculas

              if (userDoc.exists == false ||
                  userDoc.get('password') != inputPass) { //Si no existe el doc falla, si el documento con el nombre de usuario existe accedo a ese documento para obtener la contra y comparar
                print("Inicio de sesión fallido");
                const SnackBar snackBar = SnackBar(
                  content: Text('Inicio de sesión fallido'),
                );
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(snackBar);
              } else {
                print("User valido");
                const SnackBar snackBar = SnackBar(
                  content: Text('Login exitoso'),
                );
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(snackBar);
                context.pushNamed(HomeScreen.name, extra: inputUser); //paso a la pantalla homescreen
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 41, 184)),
            ),
          ),
        ],
      ),
    );
  }
}
