import 'package:diabetic/Login/new_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        userProfile = querySnapshot.docs.first;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
                
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Map<String, dynamic> profileData = userProfile!.data() as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        title: Row(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      Text(
        "Profil",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
           fontWeight: FontWeight.bold,
        )
        ),
    ],
  ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(profileData['name'] ?? 'No Name'),
            subtitle: Text('Ad'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(profileData['surname'] ?? 'No Name'),
            subtitle: Text('Soyad'),
          ),
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text(profileData['phoneNumber'] ?? 'No Name'),
            subtitle: Text('Telefon numarası'),
          ),
          ListTile(
  leading: Icon(Icons.cake),
  title: Text(
    profileData['dateOfBirth'] != null
        ? DateFormat('dd/MM/yyyy').format((profileData['dateOfBirth'] as Timestamp).toDate())
        : 'Doğum günü belirtilmemiş',
  ),
  subtitle: Text('Doğum günü'),
),

          ListTile(
            leading: Icon(Icons.email),
            title: Text(profileData['email'] ?? 'No Email'),
            subtitle: Text('Email'),
          ),
          
          SizedBox(height: 16),
          ElevatedButton(onPressed: (){
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NewLoginPage(),
  ),
);
          }, child: Text("Çıkış Yap"))
        ],
      ),
    );
  }
}
