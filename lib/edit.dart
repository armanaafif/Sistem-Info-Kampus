import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

class EditProfilePage extends StatefulWidget {
  EditProfilePage({required this.NIM, required this.Nama, required this.Email});
  final String NIM;
  final String Nama;
  final String Email;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final NIMControl = TextEditingController();
  final NamaControl = TextEditingController();
  final EmailControl = TextEditingController();
  final PasswordControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    NIMControl.text = widget.NIM;
    NamaControl.text = widget.Nama;
    EmailControl.text = widget.Email;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGrey,
        middle: Text('Ubah Profile Mahasiswa'),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            _buildTextField("NIM", NIMControl, enabled: false),
            _buildTextField("Nama", NamaControl),
            _buildTextField("Email", EmailControl),
            _buildTextField("Masukkan Password", PasswordControl,
                obscure: true),
            _buildButton("Ubah Profil", _updateProfile),
            _buildButton("Batal", () => Navigator.pop(context)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String placeholder, TextEditingController controller,
      {bool enabled = true, bool obscure = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: CupertinoTextField(
        placeholder: placeholder,
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Center(
        child: CupertinoButton.filled(
          child: Text(label),
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _updateProfile() {
    final String nim = NIMControl.text.trim();
    final String nama = NamaControl.text.trim();
    final String email = EmailControl.text.trim();
    final String password = PasswordControl.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlert("Semua field harus diisi.");
      return;
    }

    Map<String, String> data = {
      'nim': nim,
      'nama': nama,
      'email': email,
      'password': password,
    };

    _databaseReference.child('Mahasiswa').child(nim).set(data).then((_) {
      Navigator.pop(context, true); // ⬅️ Ini penting untuk trigger refresh
    }).catchError((error) {
      _showAlert("Gagal mengupdate data. Coba lagi.");
    });
  }

  void _showAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Peringatan"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
