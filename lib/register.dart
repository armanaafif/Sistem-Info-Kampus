import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final NIMControl = TextEditingController();
  final NamaControl = TextEditingController();
  final EmailControl = TextEditingController();
  final PasswordControl = TextEditingController();

  @override
  void dispose() {
    NIMControl.dispose();
    NamaControl.dispose();
    EmailControl.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3366FF),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 25),
              decoration: const BoxDecoration(
                color: Color(0xFF3366FF),
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
                    width: 100,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Pendaftaran",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    "Data Mahasiswa",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Form Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildInputField("NIM", NIMControl),
                    const SizedBox(height: 15),
                    buildInputField("Nama", NamaControl),
                    const SizedBox(height: 15),
                    buildInputField("Email", EmailControl),
                    const SizedBox(height: 15),
                    buildInputField("Password", PasswordControl, obscure: true),
                    const SizedBox(height: 20),

                    // Tombol DAFTAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String NIM = NIMControl.text;
                          String Nama = NamaControl.text;
                          String Email = EmailControl.text;
                          String Password = PasswordControl.text;

                          Map<String, String> data = {
                            'nim': NIM,
                            'nama': Nama,
                            'email': Email,
                            'password': Password,
                          };

                          _databaseReference
                              .child('Mahasiswa')
                              .child(NIM)
                              .set(data)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registrasi Berhasil'),
                                duration: Duration(seconds: 5),
                              ),
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0055DD),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Tombol Bersih & Batal
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              NIMControl.clear();
                              NamaControl.clear();
                              EmailControl.clear();
                              PasswordControl.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0055DD),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Bersih",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0055DD),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Batal",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget input
  Widget buildInputField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
