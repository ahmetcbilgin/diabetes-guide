import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class alarm extends StatefulWidget {
  @override
  _alarmState createState() => _alarmState();
}

class _alarmState extends State<alarm> {
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<String> _reminders = [];

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    _notificationsPlugin.initialize(initializationSettings);
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

  Future<void> _scheduleMedicationReminder() async {
    var scheduledNotificationDateTime = tz.TZDateTime.from(_selectedDateTime, tz.local);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medication_reminder',
      'Medication Reminder',
      channelDescription: 'Channel for medication reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      0,
      'Medication Reminder',
      'It\'s time to take your medication: ${_medicationNameController.text}, Dosage: ${_dosageController.text}',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    String reminder = '${_medicationNameController.text} - Dosage: ${_dosageController.text} at ${DateFormat('yyyy-MM-dd – HH:mm').format(_selectedDateTime)}';
    setState(() {
      _reminders.add(reminder);
    });

    _medicationNameController.clear();
    _dosageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İlaç Hatırlatıcısı',style: TextStyle(fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),),
            backgroundColor: Colors.deepPurple.shade300,),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _medicationNameController,
              decoration: InputDecoration(labelText: 'İlaç İsmi'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: 'Doz'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Tarih ve saati seç'),
              subtitle: Text(DateFormat('yyyy-MM-dd – HH:mm').format(_selectedDateTime)),
              onTap: () => _selectDateTime(context),
            ),
            ElevatedButton(
              onPressed: _scheduleMedicationReminder,
              child: Text('Oluştur'),
            ),
            SizedBox(height: 20),
            Text('Bildirimler:', style: Theme.of(context).textTheme.headline6),
            ..._reminders.map((reminder) => ListTile(title: Text(reminder))).toList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
