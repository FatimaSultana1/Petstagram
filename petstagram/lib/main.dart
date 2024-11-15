import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/providers/user_provider.dart';
import 'package:petstagram/responsive/mobile_screen_layout.dart';
import 'package:petstagram/responsive/web_screen_layout.dart';
import 'package:petstagram/responsive/responsive_layout_screen.dart';
import 'package:petstagram/screens/login_screen.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Petstagram());
}

class Petstagram extends StatelessWidget {
  const Petstagram({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(), lazy: false),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Petstagram',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // User is logged in
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else {
                // User is not logged in
                return const LoginScreen();
              }
            }
            // Otherwise, show something whilst waiting for initialization to complete
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
