import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:servicios_app/Screen/login/login_page.dart';
import 'package:servicios_app/Screen/windgets/favoritescreen.dart';
import 'package:servicios_app/Screen/windgets/notificationsscreen.dart';
import 'package:servicios_app/Screen/windgets/profile_screen.dart';

class HomeBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFF),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE4D9FF).withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: _SalomonBottomBar(),
    );
  }
}

class _SalomonBottomBar extends StatefulWidget {
  @override
  State<_SalomonBottomBar> createState() => _SalomonBottomBarState();
}

class _SalomonBottomBarState extends State<_SalomonBottomBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFF1E2749),
      unselectedItemColor: Color(0xFF1E2749).withOpacity(0.5),
      onTap: (index) {
        _onTap(context, index);
      },
      items: [
        SalomonBottomBarItem(
          icon: Icon(Icons.home, size: 35),
          title: Text("Home"),
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.favorite_border_outlined, size: 35),
          title: Text("Favorites"),
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.notifications, size: 35),
          title: Text("Notifications"),
        ),
        SalomonBottomBarItem(
          icon: Icon(Icons.person, size: 35),
          title: Text("Profile"),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _navigateWithSlideTransition(
            context, Login(), SlideTransitionType.fromTop);
        break;
      case 1:
        _navigateWithSlideTransition(
            context, FavoriteScreen(), SlideTransitionType.fromTop);
        break;
      case 2:
        _navigateWithSlideTransition(
            context, NotificationsScreen(), SlideTransitionType.fromTop);
        break;
      case 3:
        _navigateWithSlideTransition(
            context, ProfileScreen(), SlideTransitionType.fromTop);
        break;
    }
  }

  void _navigateWithSlideTransition(
      BuildContext context, Widget page, SlideTransitionType type) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin, end;
          var curve = Curves.easeInOut;

          switch (type) {
            case SlideTransitionType.fromTop:
              begin = Offset(0.0, -1.0);
              end = Offset.zero;
              break;
            case SlideTransitionType.fromBottom:
              begin = Offset(0.0, 1.0);
              end = Offset.zero;
              break;
            default:
              begin = Offset(0.0, 0.0);
              end = Offset.zero;
          }

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offset = animation.drive(tween);
          return SlideTransition(position: offset, child: child);
        },
      ),
    );
  }
}

enum SlideTransitionType {
  fromTop,
  fromBottom,
}
