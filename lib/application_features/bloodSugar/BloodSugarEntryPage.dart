import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BloodSugarEntryPage extends StatefulWidget {
  @override
  _BloodSugarEntryPageState createState() => _BloodSugarEntryPageState();
}

class _BloodSugarEntryPageState extends State<BloodSugarEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void dispose() {
    _categoryController.dispose();
    _glucoseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final entry = {
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'category': _categoryController.text.trim(),
        'datetime': Timestamp.fromDate(_selectedDateTime),
        'glucose': int.parse(_glucoseController.text),
        'note': _noteController.text.trim(),
      };
      FirebaseFirestore.instance.collection('bloodSugar').add(entry).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry saved successfully!')),
        );
        // Clear the form fields after saving
        _categoryController.clear();
        _glucoseController.clear();
        _noteController.clear();
        setState(() {
          _selectedDateTime = DateTime.now();
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving entry: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Kan Şekeri Ölçümünü Ekle',
        style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),
        
        ),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _glucoseController,
                decoration: InputDecoration(
                  labelText: 'Kan Şekeri (mg/dL)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kan şekerini giriniz';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Rakam giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori giriniz.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Not',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Not giriniz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Tarih ve Saat seç'),
                subtitle: Text(DateFormat.yMd().add_jm().format(_selectedDateTime)),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  child: Text('Kaydet'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, 
                    onPrimary: Colors.white, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
