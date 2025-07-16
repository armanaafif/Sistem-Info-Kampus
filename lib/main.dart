import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Sistem Informasi Mahasiswa';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: _title,
            home: SplashScreen(),
          );
        }

        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

// ===================== SPLASH SCREEN =====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3366FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: NetworkImage("https://unw.ac.id/_nuxt/unw.CC306KHJ.png"),
              width: 120,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text(
              'Sistem Informasi Mahasiswa',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== LOGIN PAGE =====================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String nim = nimController.text;
    String password = passwordController.text;

    dbRef.child("Mahasiswa").child(nim).get().then((snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        String dbPass = data['password'];
        if (password == dbPass) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Berhasil")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(nim: nim)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Gagal: Password Salah")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun tidak ditemukan")),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 100, bottom: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF3366FF), // biru terang
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: const [
                  Image(
                    image: NetworkImage(
                        "https://unw.ac.id/_nuxt/unw.CC306KHJ.png"),
                    width: 120,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Welcome!",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    "Universitas Ngudi Waluyo",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nimController,
                      decoration: const InputDecoration(
                        labelText: "Nim",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0044CC),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Daftar Akun Mahasiswa"),
            ),
          ],
        ),
      ),
    );
  }
}
