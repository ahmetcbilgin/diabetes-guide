import 'package:diabetic/application_features/health_tips/health_tip.dart';
import 'package:diabetic/application_features/health_tips/health_tips_data.dart';
import 'package:flutter/material.dart';

class HealthTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text("Sağlık İpuçları",
        style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
        
      ),
      body: PageView.builder(
        itemCount: healthTips.length,
        itemBuilder: (context, index) {
          HealthTip tip = healthTips[index];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Image.network(tip.imageUrl, fit: BoxFit.contain),
                ),
                Text(tip.title, style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 10),
                Text(tip.description, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}
