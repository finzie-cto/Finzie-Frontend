import 'package:finzie/providers/user_provider.dart';
import 'package:finzie/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:finzie/screens/screens.dart';
import 'package:finzie/screens/otp.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    // if (token != null) showSnackBar(context, token as String);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: {
        'sign_up': (context) => Signup(),
        'otp': (context) => MyOtp(),
        'login': (context) => LoginScreen(),
        'salary': (context) => ChatScreen()
      },
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const 
          HomeScreen()
          : Signup(),
    );
  }
}
