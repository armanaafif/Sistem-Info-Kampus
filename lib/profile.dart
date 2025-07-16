import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'edit.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class ProfilePage extends StatefulWidget {
  ProfilePage({required this.nim});
  final String nim;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<dynamic, dynamic> mappedData = {};
  String nim = "";

  @override
  void initState() {
    super.initState();
    nim = widget.nim;
    fetchData(nim);
  }

  Future<void> fetchData(String nim) async {
    final ref = _databaseReference.child("Mahasiswa").child(nim);
    final data = await ref.get();
    if (data.exists) {
      setState(() {
        mappedData = data.value as Map<dynamic, dynamic>;
      });
    }
  }

  final confirmController = TextEditingController();

  void _openConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Konfirmasi'),
          content: TextField(
            controller: confirmController,
            decoration: InputDecoration(
              labelText: 'Masukkan Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmController.clear();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                String curPass = confirmController.text;
                _databaseReference
                    .child("Mahasiswa")
                    .child(nim)
                    .get()
                    .then((snapshot) {
                  Map<dynamic, dynamic> data =
                      snapshot.value as Map<dynamic, dynamic>;
                  String dbPass = data['password'];
                  if (curPass == dbPass) {
                    _databaseReference
                        .child("Mahasiswa")
                        .child(nim)
                        .remove()
                        .then((result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Data berhasil dihapus."),
                          duration: Duration(seconds: 5),
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password Salah"),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                      duration: Duration(seconds: 5),
                    ),
                  );
                });
              },
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Mahasiswa'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: FlutterLogo(
                  size: 80.0,
                ),
              ),
            ),
            _buildInfoRow("NIM", nim),
            _buildInfoRow("Nama", mappedData['nama']?.toString() ?? "-"),
            _buildInfoRow("E-Mail", mappedData['email']?.toString() ?? "-"),
            _buildButton("Ubah Profil", Colors.blue, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    NIM: nim,
                    Nama: mappedData['nama'],
                    Email: mappedData['email'],
                  ),
                ),
              );

              if (result == true) {
                fetchData(nim);
              }
            }),
            _buildButton("Logout", Colors.blue, () {
              Navigator.pop(context);
            }),
            _buildButton("Hapus", Colors.red, () {
              _openConfirmationDialog();
            }),
          ],
        )));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 15)),
          SizedBox(height: 1),
          Container(
            width: 300,
            height: 25,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Text(value, style: TextStyle(fontSize: 20, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
