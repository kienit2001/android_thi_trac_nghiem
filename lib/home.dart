import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_project/History/history_exam.dart';
import 'package:new_project/model/user.dart';
import 'package:new_project/profije.dart';
import 'package:new_project/token/time_token.dart';

import 'API/getAPIuser.dart';
import 'home_page.dart';
import 'my_drawer_header.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isTokenRefreshScheduled = false;
  User? user_goc;
  bool isLoading = true; // Biến để theo dõi trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    startTokenRefreshLoop();
    WidgetsBinding.instance?.addObserver(this);
    getUserData().then((User? user) {
      setState(() {
        user_goc = user;
        isLoading = false; // Dữ liệu đã được tải, isLoading = false
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scheduleTokenRefresh();
  }

  var currentPage = DrawerSections.trangchu;

  @override
  Widget build(BuildContext context) {
    var container;
    String title = "";

    if (isLoading) {
      // Hiển thị trạng thái đang tải khi isLoading = true
      container = Center(
        child: CircularProgressIndicator(),
      );
      title = "Đang tải...";
    } else {
      // Hiển thị trang chính khi isLoading = false và có dữ liệu user_goc
      if (currentPage == DrawerSections.lich_su_thi) {
        container = History_exam();
        title = "Lich su thi";
      } else if (currentPage == DrawerSections.trangchu) {
        container = const Home_Page();
        title = "Trang Chu";
      } else if (currentPage == DrawerSections.thongtincanhan) {
        container = ProfilePage(user_goc);
        title = "Thông Tin cá nhân";
      } else if (currentPage == DrawerSections.dangxuat) {
        Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.push(context, route);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                if (user_goc != null) MyHeaderDrawer(user: user_goc!),
                if (user_goc == null) CircularProgressIndicator(),
                // Hiển thị một indicator khi dữ liệu đang được tải
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTokenRefreshLoop() async {
    while (true) {
      await Future.delayed(const Duration(minutes: 5));
      getTokenAfterDelay();
    }
  }

  void scheduleTokenRefresh() {
    setState(() {
      isTokenRefreshScheduled = true;
    });
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          MenuItem(
            1,
            "Trang chủ",
            Icons.home_outlined,
            currentPage == DrawerSections.trangchu ? true : false,
          ),
          MenuItem(
            2,
            "Lịch sử thi",
            Icons.history_outlined,
            currentPage == DrawerSections.lich_su_thi ? true : false,
          ),
          Divider(),
          // MenuItem(
          //   3,
          //   "Bảng điểm",
          //   Icons.tab_outlined,
          //   currentPage == DrawerSections.bangdiem ? true : false,
          // ),
          MenuItem(
            5,
            "Thông tin cá nhân",
            Icons.account_box,
            currentPage == DrawerSections.dangxuat ? true : false,
          ),
          MenuItem(
            4,
            "Đăng xuất",
            Icons.logout_outlined,
            currentPage == DrawerSections.dangxuat ? true : false,
          ),
        ],
      ),
    );
  }

  Widget MenuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.trangchu;
            } else if (id == 2) {
              currentPage = DrawerSections.lich_su_thi;
            } else if (id == 4) {
              currentPage = DrawerSections.dangxuat;
            } else if (id == 5) {
              currentPage = DrawerSections.thongtincanhan;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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

enum DrawerSections {
  trangchu,
  lich_su_thi,
  dangxuat,
  thongtincanhan,
}
