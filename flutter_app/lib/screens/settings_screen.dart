import 'package:flutter/material.dart';
import './settings/about_us_screen.dart';
import './settings/edit_profile_screen.dart';
import './settings/payment_history_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Edit Profile
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Edit Profile'),
              subtitle: const Text('Update your personal information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Payment History
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text('Payment History'),
              subtitle: const Text('View your transaction history'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentHistoryScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // About Us
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              subtitle: const Text('Learn more about our app'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
