import 'package:flutter/material.dart';
import 'package:getex_test/views/screens/contacts/contacts_screen.dart';
import 'package:getex_test/views/screens/contacts/recent_call_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key,});

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 1;
  var screens = [
    const RecentCallScreen(),
    const RecentCallScreen(),
    const HomeScreen(),
    Container()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_alt_outlined),
            label: 'DialerPad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_sharp),
            label: 'Recents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          _onItemTapped(index);
          if(_selectedIndex == 0){
            _launchContactDialerPad("");
          }
        },
      ),
    );
  }
}

void _launchContactDialerPad(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}