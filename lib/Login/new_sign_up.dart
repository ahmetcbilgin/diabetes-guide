import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewSignUp extends StatefulWidget {
  const NewSignUp({Key? key}) : super(key: key);

  @override
  State<NewSignUp> createState() => _NewSignUpState();
}

class _NewSignUpState extends State<NewSignUp> {
  late String email, password, name, surname, phoneNumber;
  DateTime? dateOfBirth;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: height * .25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Merhaba, \nKayıt Ol",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      customSizedBox(),
                      // Name Field
                      TextFormField(
                        validator: (value) => value!.isEmpty ? "Bilgileri Eksiksiz Doldurunuz." : null,
                        onSaved: (value) => name = value!,
                        decoration: customInputDecoration("Ad"),
                      ),
                      customSizedBox(),
                      // Surname Field
                      TextFormField(
                        validator: (value) => value!.isEmpty ? "Bilgileri Eksiksiz Doldurunuz." : null,
                        onSaved: (value) => surname = value!,
                        decoration: customInputDecoration("Soyad"),
                      ),
                      customSizedBox(),
                      // Phone Number Field
                      TextFormField(
                        validator: (value) => value!.isEmpty ? "Bilgileri Eksiksiz Doldurunuz." : null,
                        onSaved: (value) => phoneNumber = value!,
                        decoration: customInputDecoration("Telefon Numarası"),
                      ),
                      customSizedBox(),
                      // Email Field
                      TextFormField(
                        validator: (value) => value!.isEmpty ? "Bilgileri Eksiksiz Doldurunuz." : null,
                        onSaved: (value) => email = value!,
                        decoration: customInputDecoration("Email"),
                      ),
                      customSizedBox(),
                      // Password Field
                      TextFormField(
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? "Bilgileri Eksiksiz Doldurunuz." : null,
                        onSaved: (value) => password = value!,
                        decoration: customInputDecoration("Şifre"),
                      ),
                      customSizedBox(),
                      // Date of Birth Picker
                      ListTile(
                        title: Text('Doğum Tarihi'),
                        subtitle: Text(dateOfBirth == null
                            ? 'Tarih Seç'
                            : DateFormat('dd/MM/yyyy').format(dateOfBirth!)),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateOfBirth = pickedDate;
                            });
                          }
                        },
                      ),
                      customSizedBox(),
                      // Sign Up Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                var userResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
                                // Save additional data to Firestore
                                await firestore.collection('users').doc(userResult.user!.uid).set({
                                  'name': name,
                                  'surname': surname,
                                  'phoneNumber': phoneNumber,
                                  'dateOfBirth': dateOfBirth,
                                  'email' : email,
                                  // other fields as needed
                                });
                                formKey.currentState!.reset();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kayıt alındı, ana sayfaya yönlendiriliyorsunuz.")));
                                Navigator.pushReplacementNamed(context, "/loginPage");
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                          child: Text("Hesap Oluştur"),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, "/loginPage"),
                          child: Text("Ana Ekrana Gitmek İstiyorum"),
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

  Widget customSizedBox() => SizedBox(
    height: 20,
  );

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
