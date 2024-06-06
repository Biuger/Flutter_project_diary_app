import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_flutter/screens/login_screen.dart';
import 'package:proyecto_flutter/services/user_service.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<UserService>(create: (_) => UserService()),
      ],
      child: MaterialApp( 
        title: 'Diario Personal',
      
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,  fontSize: 30,
            ),
            
            color: Color(0xFFC0D4FF), 
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
