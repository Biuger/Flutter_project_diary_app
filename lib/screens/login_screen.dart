import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_flutter/screens/home_screen.dart';
import 'package:proyecto_flutter/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double fontSize = constraints.maxWidth / 15; // Adjust as needed
            return Text(
              'Bienvenido a tu diario personal!',
              style: TextStyle(fontSize: fontSize, color: Colors.black),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;

                  // Validar que el correo electrónico y la contraseña no estén vacíos
                  if (email.isEmpty || password.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Por favor, ingresa un correo electrónico y una contraseña.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // Realizar la solicitud HTTP al servidor backend
                  final response = await http.get(Uri.parse(
                      'http://10.0.2.2:8888/login?email=$email&password=$password'));

                  // Manejar la respuesta del servidor
                  if (response.statusCode == 200) {
                    // Parsear la respuesta JSON
                    final Map<String, dynamic> responseData =
                        json.decode(response.body);

                    // Extraer el ID del usuario
                    final ID = responseData['ID'];
                    final username = responseData['username'];

                    // Autenticación exitosa
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          ID: ID,
                          username: username,
                        ),
                      ),
                    );
                  } else {
                    // Autenticación fallida
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Correo electrónico o contraseña incorrectos.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Iniciar Sesión'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Registrar'),
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                      fontSize: 18, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
