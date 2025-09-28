import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome card
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.rate_review),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome back",
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Manage feedback & view analytics",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/feedbackForm'),
                        child: const Text('New Feedback'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HomeActionCard(
                    title: 'All Feedback',
                    icon: Icons.list_alt,
                    onTap: () => Navigator.pushNamed(context, '/feedbackList'),
                  ),
                  _HomeActionCard(
                    title: 'Analytics',
                    icon: Icons.show_chart,
                    onTap: () => Navigator.pushNamed(context, '/analytics'),
                  ),
                  _HomeActionCard(
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile tapped')),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Placeholder for recent items
              Expanded(
                child: Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text(
                            'Recent Feedback',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                        const Divider(color: Colors.white12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: 4,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.white10),
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: CircleAvatar(child: Text('S${i + 1}')),
                                title: Text('Feedback title ${i + 1}'),
                                subtitle: Text(
                                  'Short preview of feedback message...',
                                ),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/feedbackDetail',
                                  arguments: {'id': i},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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

class _HomeActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, size: 30, color: Colors.white70),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
