import 'package:flutter/material.dart';
import 'package:rick_and_morty_isar/features/characters/presentation/charactrers_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  void changeTab(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(index: index),
      bottomNavigationBar: _NavBar(
        onTabChange: changeTab,
        index: index,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: const [
        CharactersPage(),
        Center(child: Icon(Icons.recycling_rounded))
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    Key? key,
    required this.onTabChange,
    required this.index,
  }) : super(key: key);

  final int index;
  final Function(int value) onTabChange;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTabChange,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Characters',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
