import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Logo Container
              Container(
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Merhaba, \nhoşgeldin", 
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                      ),
                      customSizedBox(),
                      // Email Field
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) return "Bilgileri Eksiksiz Doldurunuz.";
                          return null;
                        },
                        onSaved: (value) => email = value!,
                        decoration: customInputDecoration("Email"),
                      ),
                      customSizedBox(),
                      // Password Field
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return "Bilgileri Eksiksiz Doldurunuz.";
                          return null;
                        },
                        onSaved: (value) => password = value!,
                        decoration: customInputDecoration("Şifre"),
                      ),
                      customSizedBox(),
                      // Forgot Password Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _showPasswordResetDialog,
                          child: Text("Şifremi Unuttum"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            onPrimary: Colors.white,
                          ),
                        ),
                      ),
                      customSizedBox(),
                      // Login Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text("Giriş Yap"),
                        ),
                      ),
                      customSizedBox(),
                      // Sign Up Navigation Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, "/signUp"),
                          child: Text("Hesap Oluştur"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacementNamed(context, "/anaEkran");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Giriş hatası: ${e.toString()}")));
      }
    }
  }

  void _showPasswordResetDialog() {
    final TextEditingController _resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Şifre Sıfırlama'),
          content: TextField(
            controller: _resetEmailController,
            decoration: InputDecoration(hintText: 'Email adresinizi giriniz'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Sıfırla'),
              onPressed: () {
                _resetPassword(_resetEmailController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen email adresinizi giriniz')));
      return;
    }

    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Şifre sıfırlama linki gönderildi')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bir hata oluştu, lütfen tekrar deneyin')));
    }
  }

  Widget customSizedBox() => SizedBox(height: 20);

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }
}
