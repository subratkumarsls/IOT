import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceManagementPage extends StatelessWidget {
  const DeviceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in!')),
      );
    }

    final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Stats'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading values.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              !(snapshot.data?.snapshot.exists ?? false)) {
            return const Center(child: Text('No data found.'));
          }

          // Defensive: always fallback to empty Map if null.
          final data = (snapshot.data?.snapshot.value as Map?) ?? {};

          // Fetch values, fallback to 0 if missing
          final current = (data['current'] is num) ? (data['current'] as num).toDouble() : 0.0;
          final energy  = (data['energy']  is num) ? (data['energy']  as num).toDouble()  : 0.0;
          final power   = (data['power']   is num) ? (data['power']   as num).toDouble()   : 0.0;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _valueCard(
                  icon: Icons.flash_on,
                  label: 'Current',
                  value: '$current A',
                  color: Colors.cyanAccent,
                ),
                const SizedBox(height: 24),
                _valueCard(
                  icon: Icons.energy_savings_leaf,
                  label: 'Energy',
                  value: '${energy.toStringAsFixed(3)} kWh',
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 24),
                _valueCard(
                  icon: Icons.bolt,
                  label: 'Power',
                  value: '$power W',
                  color: Colors.orangeAccent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _valueCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
