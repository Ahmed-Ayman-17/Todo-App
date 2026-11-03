import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/app_auth_provider.dart';
import 'package:todo_app/ui/home/list/task_list_screen.dart';
import 'package:todo_app/ui/home/setting/setting_screen.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:todo_app/ui/utils/dialog_utils.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTapIndex = 0;

  var tabs = [const ListScreen(), const SettingScreen()];

  Future<void> _logout() async {
    // اسأل المستخدم هل متأكد من الـ Logout
    DialogUtils.showMessage(
      context,
      message: 'Are you sure you want to log out?',
      posBottomTitle: 'Logout',
      posBottomAction: () async {
        // أغلق الـ Dialog
        Navigator.of(context, rootNavigator: true).pop();

        // اعرض Loading أثناء الـ Sign Out
        DialogUtils.showLoadingDialog(context);

        // استدعِ signOut من الـ Provider (يمسح State + Firebase)
        await Provider.of<AppAuthProvider>(context, listen: false).signOut();

        if (!mounted) return;
        DialogUtils.hideDialog(context);

        // انتقل للـ Login بدون إمكانية الرجوع للـ Home
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        elevation: 0,
        // زرار الـ Logout في الـ AppBar
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 25,
        child: BottomNavigationBar(
          currentIndex: selectedTapIndex,
          onTap: (newSelectedIndex) {
            selectedTapIndex = newSelectedIndex;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
        ),
      ),
      body: tabs[selectedTapIndex],
    );
  }
}
