import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class NewStatisticsPage extends StatefulWidget {
  @override
  _NewStatisticsPageState createState() => _NewStatisticsPageState();
}

class _NewStatisticsPageState extends State<NewStatisticsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final User? currentUser = FirebaseAuth.instance.currentUser;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ölçüm ve İstatistik',
        style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('bloodSugar').orderBy('datetime').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final documents = snapshot.data!.docs;

          
          List<FlSpot> spots = documents
              .map((doc) => FlSpot(
                    (doc.data() as Map<String, dynamic>)['datetime'].toDate().millisecondsSinceEpoch.toDouble(),
                    (doc.data() as Map<String, dynamic>)['glucose'].toDouble(),
                  ))
              .toList();

          
          List<Widget> listItems = documents
              .map((doc) => ListTile(
                    title: Text("${(doc.data() as Map<String, dynamic>)['category']}"),
                    subtitle: Text("${(doc.data() as Map<String, dynamic>)['glucose']} mg/dL"),
                    trailing: Text(DateFormat.yMd().add_jm().format((doc.data() as Map<String, dynamic>)['datetime'].toDate())),
                  ))
              .toList();

          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData( show:false),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.deepPurple,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView(
                  children: listItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
