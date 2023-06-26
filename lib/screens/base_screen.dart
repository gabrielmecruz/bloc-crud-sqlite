import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_crud_sqlite/models/page_manager.dart';
import 'package:bloc_crud_sqlite/screens/home/home_screen.dart';
import 'package:bloc_crud_sqlite/screens/student/edit_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [HomeScreen(), StudentEditScreen()],
      ),
    );
  }
}
