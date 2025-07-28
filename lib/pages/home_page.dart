import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot/widgets/drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference deviceRef;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      deviceRef = FirebaseDatabase.instance.ref('users/${user.uid}/devices');
    }
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
      if (!isConnected) {
        _showPopup('No internet connection. Please connect to the internet.');
      }
    });
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Not signed in!', style: TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IoT Manager',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<DatabaseEvent>(
        stream: deviceRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data.', style: TextStyle(color: Colors.red)),
            );
          }

          if (!snapshot.hasData || !(snapshot.data?.snapshot.exists ?? false)) {
            return const Center(child: Text('No devices found.'));
          }

          final deviceMap = (snapshot.data?.snapshot.value as Map?)?.cast<String, dynamic>() ?? {};

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: deviceMap.entries.map((entry) {
                final deviceName = entry.key;
                final deviceValue = entry.value;

                final isOn = deviceValue == 0;
                final color = isOn ? Colors.deepPurpleAccent : Colors.grey.shade300;
                final textColor = isOn ? Colors.white : Colors.black87;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Material(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () async {
                        final newValue = isOn ? 1 : 0;
                        try {
                          await deviceRef.child(deviceName).set(newValue);
                        } catch (e) {
                          _showPopup("Failed to update device state.");
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        child: Text(
                          deviceName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
