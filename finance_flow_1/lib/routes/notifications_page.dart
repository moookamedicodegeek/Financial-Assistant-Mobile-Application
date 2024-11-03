import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/models/notification_model.dart';
import 'package:finance_flow_1/services/user_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final UserService _userService = UserService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  bool _isFetched = false; // Prevent redundant fetches

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (_isFetched) return; // Avoid redundant calls
    setState(() => _isLoading = true);

    String? userId = _userService.getCurrentUserId();
    if (userId != null) {
      List<Map<String, dynamic>> notificationsData =
          await _userService.getNotifications(userId);

      DateTime now = DateTime.now();
      _notifications = notificationsData
          .map((data) => NotificationModel.fromMap(data, data['key']))
          .where((notification) =>
              notification.date.month == now.month &&
              notification.date.year == now.year)
          .toList();
    } else {
      print("User ID is null.");
    }

    setState(() {
      _isLoading = false;
      _isFetched = true; // Mark as fetched to prevent future fetches
    });
  }

  Future<void> _deleteNotification(String notificationId) async {
    String? userId = _userService.getCurrentUserId();
    if (userId != null) {
      await _userService.deleteNotification(userId, notificationId);
      setState(() {
        _notifications.removeWhere((n) => n.id == notificationId);
      });
    } else {
      print("User ID is null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Notifications',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications for this month.'))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.5),
                      child: Material(
                        elevation: 5,
                        shadowColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1,
                            ),
                          ),
                          title: Text(
                            notification.message,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Date: ${notification.date.day}/${notification.date.month}/${notification.date.year}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: CustomIconButton(
                            icon: Icons.delete,
                            iconColor: Theme.of(context).colorScheme.tertiary,
                            buttonColor: Theme.of(context).colorScheme.primary,
                            onPressed: () => _deleteNotification(
                              notification.id,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
