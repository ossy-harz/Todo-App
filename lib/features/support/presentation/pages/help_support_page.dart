import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Help Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.help_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Help',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHelpItem(
                    context,
                    'Getting Started',
                    'Learn the basics of using the Todo app',
                    Icons.play_circle_outline,
                    () => _showGettingStartedDialog(context),
                  ),
                  _buildHelpItem(
                    context,
                    'Creating Tasks',
                    'How to create and manage your tasks',
                    Icons.add_task,
                    () => _showCreatingTasksDialog(context),
                  ),
                  _buildHelpItem(
                    context,
                    'Setting Reminders',
                    'Configure notifications and reminders',
                    Icons.notifications,
                    () => _showRemindersDialog(context),
                  ),
                  _buildHelpItem(
                    context,
                    'Using Categories',
                    'Organize tasks with categories and tags',
                    Icons.category,
                    () => _showCategoriesDialog(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // FAQ Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.quiz, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Frequently Asked Questions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFAQItem(
                    'How do I sync my tasks across devices?',
                    'Your tasks are automatically synced through your account. Make sure you\'re logged in with the same account on all devices.',
                  ),
                  _buildFAQItem(
                    'Can I use the app offline?',
                    'Yes! The app works offline and will sync your changes when you\'re back online.',
                  ),
                  _buildFAQItem(
                    'How do I set up recurring tasks?',
                    'When creating or editing a task, scroll down to the Recurrence section and select your preferred repeat interval.',
                  ),
                  _buildFAQItem(
                    'Why am I not receiving notifications?',
                    'Check your device notification settings and ensure the app has permission to send notifications.',
                  ),
                  _buildFAQItem(
                    'How do I backup my data?',
                    'Your data is automatically backed up to the cloud. You can also export your tasks from the settings menu.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Contact Support Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.support_agent, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Contact Support',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    context,
                    'Email Support',
                    'Get help via email',
                    Icons.email,
                    () => _launchEmail(),
                  ),
                  _buildContactItem(
                    context,
                    'Live Chat',
                    'Chat with our support team',
                    Icons.chat,
                    () => _showChatDialog(context),
                  ),
                  _buildContactItem(
                    context,
                    'Report a Bug',
                    'Found an issue? Let us know',
                    Icons.bug_report,
                    () => _showBugReportDialog(context),
                  ),
                  _buildContactItem(
                    context,
                    'Feature Request',
                    'Suggest new features',
                    Icons.lightbulb_outline,
                    () => _showFeatureRequestDialog(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // App Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        'App Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem('Version', '1.0.0'),
                  _buildInfoItem('Last Updated', 'January 2024'),
                  _buildInfoItem('Developer', 'Todo App Team'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _launchURL('https://todoapp.com/privacy'),
                          child: const Text('Privacy Policy'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _launchURL('https://todoapp.com/terms'),
                          child: const Text('Terms of Service'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _showGettingStartedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Getting Started'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome to Todo App! Here\'s how to get started:'),
              SizedBox(height: 16),
              Text('1. Create your first task by tapping the + button'),
              SizedBox(height: 8),
              Text('2. Set due dates and reminders to stay organized'),
              SizedBox(height: 8),
              Text('3. Use categories to organize your tasks'),
              SizedBox(height: 8),
              Text('4. Mark tasks as complete when done'),
              SizedBox(height: 8),
              Text('5. Use the calendar view to see upcoming tasks'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showCreatingTasksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Creating Tasks'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('To create a new task:'),
              SizedBox(height: 16),
              Text('1. Tap the + button on the main screen'),
              SizedBox(height: 8),
              Text('2. Enter a title and description'),
              SizedBox(height: 8),
              Text('3. Set priority (Low, Medium, High)'),
              SizedBox(height: 8),
              Text('4. Choose a category and add tags'),
              SizedBox(height: 8),
              Text('5. Set due date and reminders'),
              SizedBox(height: 8),
              Text('6. Add subtasks if needed'),
              SizedBox(height: 8),
              Text('7. Configure recurrence for repeating tasks'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showRemindersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setting Reminders'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('To set up reminders:'),
              SizedBox(height: 16),
              Text('1. First set a due date for your task'),
              SizedBox(height: 8),
              Text('2. Toggle the "Set Reminder" switch'),
              SizedBox(height: 8),
              Text('3. Choose when you want to be reminded'),
              SizedBox(height: 8),
              Text('4. Make sure notifications are enabled in your device settings'),
              SizedBox(height: 16),
              Text('Note: You need to allow notifications for the app to receive reminders.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Using Categories'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Categories help organize your tasks:'),
              SizedBox(height: 16),
              Text('• Work: Professional tasks and projects'),
              SizedBox(height: 8),
              Text('• Personal: Personal goals and activities'),
              SizedBox(height: 8),
              Text('• Errands: Shopping and daily tasks'),
              SizedBox(height: 8),
              Text('• Health: Medical appointments and fitness'),
              SizedBox(height: 8),
              Text('• Learning: Educational goals and courses'),
              SizedBox(height: 8),
              Text('• Social: Events and social activities'),
              SizedBox(height: 16),
              Text('You can also add custom tags to further organize your tasks.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text('Live chat feature is coming soon! For now, please use email support or report a bug.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Bug Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Please describe the bug in detail...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would send the bug report
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bug report submitted. Thank you!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showFeatureRequestDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feature Request'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Feature Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Please describe the feature you\'d like to see...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would send the feature request
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature request submitted. Thank you!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@todoapp.com',
      query: 'subject=Todo App Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
