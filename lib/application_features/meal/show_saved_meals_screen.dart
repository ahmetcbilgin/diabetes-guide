import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowSavedMealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kaydedilmiş Öğünler',style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
            backgroundColor: Colors.deepPurple.shade300,),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('meals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              
              String type = data['type'] ?? 'Not Specified';
              String description = data['description'] ?? 'No Description';

              return ListTile(
                title: Text(type),
                subtitle: Text(description),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
