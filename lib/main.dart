import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BiometricAuthScreen(), // ✅ Biometric before HomeScreen
  ));
}

/// 🔐 **Biometric Authentication Before App Opens**
class BiometricAuthScreen extends StatefulWidget {
  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to proceed',
        options: AuthenticationOptions(stickyAuth: true),
      );
    } catch (e) {
      print("Biometric Auth Error: $e");
    }

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      _authenticateUser(); // 🔁 Keep asking until successful
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// 🏠 **HomeScreen** - Main Screen with Navigation
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Memory Aid App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MedicalRemindersScreen())),
              child: Text("💊 Medical Reminders"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => GeneralRemindersScreen())),
              child: Text("📅 General Reminders"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SmartSuggestionsScreen())),
              child: Text("🧠 Smart Suggestions"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MemorySearchScreen())),
              child: Text("🔍 Search Memories"),
            ),
          ],
        ),
      ),
    );
  }
}

/// 💊 **Medical Reminders**
class MedicalRemindersScreen extends StatefulWidget {
  @override
  _MedicalRemindersScreenState createState() => _MedicalRemindersScreenState();
}

class _MedicalRemindersScreenState extends State<MedicalRemindersScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<String> medicalReminders = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings = InitializationSettings(android: androidInit);
    notificationsPlugin.initialize(initSettings);
  }

  void _addMedicalReminder() {
    TextEditingController titleController = TextEditingController();
    setState(() => medicalReminders.add(titleController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medical Reminders")),
      body: ListView.builder(
        itemCount: medicalReminders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicalReminders[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() => medicalReminders.removeAt(index));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedicalReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}

/// 📅 **General Reminders**
class GeneralRemindersScreen extends StatefulWidget {
  @override
  _GeneralRemindersScreenState createState() => _GeneralRemindersScreenState();
}

class _GeneralRemindersScreenState extends State<GeneralRemindersScreen> {
  List<String> reminders = [];

  void _addReminder() {
    TextEditingController titleController = TextEditingController();
    setState(() => reminders.add(titleController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("General Reminders")),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reminders[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() => reminders.removeAt(index));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}

/// 🧠 **Smart Suggestions Screen (AI-Powered Memory Aid)**
class SmartSuggestionsScreen extends StatefulWidget {
  @override
  _SmartSuggestionsScreenState createState() => _SmartSuggestionsScreenState();
}

class _SmartSuggestionsScreenState extends State<SmartSuggestionsScreen> {
  final TextEditingController _queryController = TextEditingController();
  String suggestion = "Ask something about your past activities!";

  void _generateSuggestion(String query) {
    setState(() {
      suggestion = "Based on your past, here's a helpful reminder: Stay hydrated and take your medicine on time!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _queryController,
              decoration: InputDecoration(labelText: "Ask about past events"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _generateSuggestion(_queryController.text),
              child: Text("Get Suggestion"),
            ),
            SizedBox(height: 20),
            Text(suggestion, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// 🔍 **Memory Search (AI-Powered)**
class MemorySearchScreen extends StatefulWidget {
  @override
  _MemorySearchScreenState createState() => _MemorySearchScreenState();
}

class _MemorySearchScreenState extends State<MemorySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> allMemories = [
    "Doctor's advice: Take vitamin D daily",
    "Met John at the park",
    "Blood pressure check-up reminder",
    "Birthday party on April 10",
    "Drink more water",
  ];

  List<String> filteredResults = [];

  void _searchMemory(String query) {
    setState(() {
      filteredResults = allMemories
          .where((memory) => memory.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🔍 Search Memory Notes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search your memories...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchMemory(_searchController.text),
                ),
              ),
              onChanged: (value) => _searchMemory(value),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredResults.isEmpty
                  ? Center(child: Text("No results found"))
                  : ListView.builder(
                      itemCount: filteredResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredResults[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}