import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SaveMealScreen extends StatefulWidget {
  @override
  _SaveMealScreenState createState() => _SaveMealScreenState();
}

class _SaveMealScreenState extends State<SaveMealScreen> {
  final _mealTypeController = TextEditingController();
  final _mealDescriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedMealType; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Öğün Kaydet',style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
            backgroundColor: Colors.deepPurple.shade300,),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedMealType,
              hint: Text('Öğün türünü seç'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMealType = newValue;
                });
              },
              items: ['Kahvaltı', 'Öğle Yemeği', 'Akşam Yemeği', 'Ara Öğün']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _mealDescriptionController,
              decoration: InputDecoration(labelText: 'Açıklama'),
               keyboardType: TextInputType.multiline,
                maxLines: null,
                 textInputAction: TextInputAction.newline,
            ),

            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Tarih'),
              onTap: () => _selectDate(context),
              readOnly: true, 
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Saat'),
              onTap: () => _selectTime(context),
              readOnly: true, 
            ),
            
            ElevatedButton(
              onPressed: () => _saveMeal(context),
              child: Text('Öğünü Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMeal(BuildContext context) async {

     DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
  TimeOfDay selectedTime = TimeOfDay(
    hour: int.parse(_timeController.text.split(':')[0]),
    minute: int.parse(_timeController.text.split(':')[1]),
  );
  DateTime dateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
    FirebaseFirestore.instance.collection('meals').add({
      'type': _selectedMealType ?? 'Not Specified',
      'description': _mealDescriptionController.text,
      'dateTime': DateTime.now(),
    });

    _mealDescriptionController.clear();
    _dateController.clear();
    _timeController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meal saved successfully')));
  }

   Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    _mealTypeController.dispose();
    _mealDescriptionController.dispose();
    super.dispose();
  }
}
