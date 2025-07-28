import 'package:flutter/material.dart';
import 'package:iot/utils/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.deepPurpleAccent,
      child: ListView(
        children: [
          _buildDrawerHeader(user),
          _buildDivider(),
          _buildMenuItem(Icons.home, "Home", AppRoutes.home, context),
          _buildMenuItem(
            Icons.device_hub,
            "Manage Devices",
            AppRoutes.devices,
            context,
          ),
          _buildMenuItem(
            Icons.receipt,
            "Your Monthly Bill",
            AppRoutes.bills,
            context,
          ),
          _buildDivider(),
          _buildSignOutItem(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(User? user) {
    final displayName = user?.displayName ?? "IoT User";
    final email = user?.email ?? "unknown@iot.com";

    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: Colors.deepPurple),
      accountName: Text(displayName),
      accountEmail: Text(email),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.smart_toy, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white30,
      thickness: 0.5,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String route,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (Route<dynamic> route) =>
              route.settings.name == AppRoutes.home,
        );
      },
    );
  }

  Widget _buildSignOutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.white),
      title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
      onTap: () => _showSignOutDialog(context),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Sign Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                AppRoutes.login,
                (Route<dynamic> route) => false,
              );
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
