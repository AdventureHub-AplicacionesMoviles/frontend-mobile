import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _receiveEmails = false;
  bool _receiveNotifications = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _receiveEmails = _prefs.getBool('receiveEmails') ?? false;
      _receiveNotifications = _prefs.getBool('receiveNotifications') ?? false;
    });
  }

  Future<void> _updateReceiveEmails(bool value) async {
    setState(() {
      _receiveEmails = value;
    });
  }

  Future<void> _updateReceiveNotifications(bool value) async {
    setState(() {
      _receiveNotifications = value;
    });
  }

  Future<bool> _onWillPop() async {
    if (_receiveEmails != (_prefs.getBool('receiveEmails') ?? false) ||
        _receiveNotifications !=
            (_prefs.getBool('receiveNotifications') ?? false)) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Guardar cambios?'),
          content:
              const Text('Hay cambios sin guardar. ¿Desea salir sin guardar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Salir sin guardar'),
            ),
          ],
        ),
      );

      return shouldExit ?? false;
    }

    return true;
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('receiveEmails', _receiveEmails);
    await _prefs.setBool('receiveNotifications', _receiveNotifications);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text('Notifications promotional'),
              subtitle: const Text('Receive promotional'),
              trailing: Switch(
                value: _receiveEmails,
                onChanged: _updateReceiveEmails,
              ),
            ),
            ListTile(
              title: const Text('Notifications offers'),
              subtitle: const Text('Receive offers'),
              trailing: Switch(
                value: _receiveNotifications,
                onChanged: _updateReceiveNotifications,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
