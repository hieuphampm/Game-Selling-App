import 'package:flutter/material.dart';
import './settings/about_us_screen.dart';
import './settings/edit_profile_screen.dart';
import './settings/payment_history_screen.dart';
import './settings/achievement_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<int> _fetchUserCoins() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 0;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return doc.exists ? (doc.data()?['coins'] as int? ?? 0) : 0;
    } catch (e) {
      print('Error fetching user coins: $e');
      return 0;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).pushReplacementNamed('/login');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Logged out')));
  }

  Future<Map<String, String>> _fetchGameCodes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return {};

      final snapshot = await FirebaseFirestore.instance
          .collection('purchased_games')
          .where('userId', isEqualTo: user.uid)
          .get();

      return Map.fromEntries(snapshot.docs.map((doc) {
        final data = doc.data();
        return MapEntry(data['name'] as String, data['code'] as String);
      }));
    } catch (e) {
      print('Error fetching game codes: $e');
      return {};
    }
  }

  void _showGameCodes() async {
    final gameCodes = await _fetchGameCodes();
    if (gameCodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No game codes available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1a1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Game Codes',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: gameCodes.length,
              itemBuilder: (context, index) {
                final entry = gameCodes.entries.elementAt(index);
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            color: Color(0xFFb0b0b0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD9F5).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: Color(0xFFFFD9F5),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FutureBuilder<int>(
                  future: _fetchUserCoins(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Coins: Loading...',
                        style: TextStyle(
                          color: Color(0xFFb0b0b0),
                          fontSize: 14,
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Text(
                        'Coins: 0',
                        style: TextStyle(
                          color: Color(0xFFb0b0b0),
                          fontSize: 14,
                        ),
                      );
                    } else {
                      return Text(
                        'Coins: ${snapshot.data}',
                        style: const TextStyle(
                          color: Color(0xFFFFD9F5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
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
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('Achievements'),
              subtitle: const Text('View your game milestones'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AchievementScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
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
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.vpn_key),
              title: const Text('Game Codes'),
              subtitle: const Text('View your game activation codes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showGameCodes,
            ),
          ),
          const SizedBox(height: 12),
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
                    builder: (context) => const AboutUsScreen(),
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
