import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/utils/notification_bloc.dart';

import '../../constants/constants.dart';
import '../../utils/global.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  Function(int index)? onTap;

  CustomBottomNavigationBar({this.onTap});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late StreamSubscription subscription;
  var currentIndex = 0;
  final List<String> _imageNames = [
    'images/data.png',
    'images/tracking.png',
    'images/stats.png',
    'images/account.png'
  ];
  final List<String> _labels = [
    'Trainers',
    'Tracking',
    'My Stats',
    'My Account'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      if (event == kTabBarPageChangeToRoot) {
        print('gameUtil.currentPage;=${gameUtil.currentPage}');
        if (mounted) {
          setState(() {
            this.currentIndex = gameUtil.currentPage;
          });
        }
      }else if(event == kStatsToTracking || event == kStatsToAccount) {
        if (mounted) {
          setState(() {
            this.currentIndex = gameUtil.currentPage;
          });
          EventBus().sendEvent(kTabBarPageChange);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 12,
      selectedItemColor: Colors.black,
      items: _imageNames.map((item) {
        return BottomNavigationBarItem(
            icon: _buildIcon(Image(
              image: AssetImage(item),
              width: 20,
              color: this.currentIndex == _imageNames.indexOf(item)
                  ? Colors.black
                  : Constants.baseGreyStyleColor,
            )),
            label: _labels[_imageNames.indexOf(item)]);
      }).toList(),
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      unselectedItemColor: Constants.baseGreyStyleColor,
      selectedLabelStyle: TextStyle(
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.w400,
      ),
      onTap: (index) {
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (index == gameUtil.currentPage) {
          return;
        }
        setState(() {
          this.currentIndex = index;
        });

        gameUtil.currentPage = this.currentIndex;
        EventBus().sendEvent(kTabBarPageChange);
      },
    );
  }

  Widget _buildIcon(Widget icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(height: 6),
      ],
    );
  }
}
