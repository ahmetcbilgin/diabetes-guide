import 'package:diabetic/application_features/exercise_tips/exercise_class.dart';
import 'package:flutter/material.dart';

class ExerciseSuggestionsPage extends StatelessWidget {
  final List<Exercise> exercises;

  ExerciseSuggestionsPage({Key? key, required this.exercises}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Egzersiz Önerileri",
        style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: PageView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(exercise.imageUrl), 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(exercise.name, style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(exercise.description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
