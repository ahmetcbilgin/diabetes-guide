import 'package:diabetic/application_features/bloodSugar/BloodSugarEntryPage.dart';
import 'package:diabetic/application_features/statics/NewStatisticsPage.dart';
import 'package:diabetic/application_features/reminder/alarm.dart';
import 'package:diabetic/application_features/exercise_tips/exercise_data.dart';
import 'package:diabetic/application_features/exercise_tips/exercise_suggestions_page.dart';
import 'package:diabetic/application_features/meal/food_tracker_page.dart';
import 'package:diabetic/application_features/health_tips/health_tips_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar:AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        title: Row(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      Icon(Icons.water_drop,color: Colors.white),
      SizedBox(width: 20), 
      Text(
        "Diyabet Rehberi",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
           fontWeight: FontWeight.bold,
        )
        ),
    ],
  ),
  centerTitle: true, 
      ) ,
      body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Hoş geldin, \nAhmet', 
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            children: <Widget>[
              _buildGridButton('Kan Şekeri', Icons.bloodtype, context),
              _buildGridButton('İstatistik', Icons.bar_chart, context),
              _buildGridButton('İlaç Hatırlatıcısı', Icons.alarm, context),
              _buildGridButton('Besin Takibi', Icons.restaurant, context),
              _buildGridButton('Egzersiz', Icons.directions_run, context),
              _buildGridButton('Sağlık İpuçları', Icons.search, context),
            ],
          ),
        ),
      ],
    ),

      
      /*bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purple.shade50,
        color: Colors.deepPurple.shade400,
        animationDuration: Duration(milliseconds: 300),
        items: [
        Icon(Icons.home),
        Icon(Icons.person),
      ],
      
    
    )*/
    );
  }

  Widget _buildGridButton(String title, IconData iconData, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Kan Şekeri') {
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BloodSugarEntryPage()),
  );
      } else if(title == 'İstatistik'){
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewStatisticsPage()),
);

      }
      else if(title == 'İlaç Hatırlatıcısı'){
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => alarm()),
);

      }
      else if(title == 'Egzersiz'){
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ExerciseSuggestionsPage(exercises: exercises),
  ),
);

      }
      else if(title == 'Sağlık İpuçları'){
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => HealthTipsPage(),
  ),
);

      }
      else if(title == 'Besin Takibi'){
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FoodTrackerPage(),
  ),
);

      }
      
      else {
        
      }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade300, 
          borderRadius: BorderRadius.circular(16), 
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 48.0, color: Colors.white), 
            SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white), 
            ),
          ],
        ),
      ),
    );
  }
}


