import '../../utils/debug_utils.dart';
import 'package:flutter/material.dart';
import '../../widgets/shared/appbar.dart';
import '../../widgets/shared/navigationbar.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/setting_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: MyNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          debugPrintInfo('UI', 'MainScreen currentIndex = $index');
        },
      ),
    );
  }
}
