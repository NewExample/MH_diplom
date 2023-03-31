import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:megaholod_client/presentation/home/home_screen.dart';
import 'package:megaholod_client/presentation/info/info_screen.dart';
import 'package:megaholod_client/presentation/profile/profile_screen.dart';
import 'package:megaholod_client/presentation/shops/shops_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    InfoScreen(),
    ShopsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff0D0140),
    ));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff092B95),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              height: 24,
              color: _selectedIndex == 0 ? Colors.white : Colors.white54,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/info.svg',
              height: 24,
              color: _selectedIndex == 1 ? Colors.white : Colors.white54,
            ),
            label: 'ПОЛЕЗНАЯ ИНФОРМАЦИЯ',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/shops.svg',
              height: 24,
              color: _selectedIndex == 2 ? Colors.white : Colors.white54,
            ),
            label: 'Сервисные станции',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/profile.svg',
              height: 24,
              color: _selectedIndex == 3 ? Colors.white : Colors.white54,
            ),
            label: 'ДАННЫЕ О ПОЛЬЗОВАТЕЛЕ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
