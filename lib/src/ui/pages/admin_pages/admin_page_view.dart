import 'package:flutter/material.dart';
import 'package:kaiu/src/ui/pages/admin_pages/kaiju_form.dart';
import 'package:kaiu/src/ui/pages/admin_pages/kaiju_form_habs.dart';
import 'package:kaiu/src/ui/pages/admin_pages/kaiju_form_image.dart';


class AdminPageView extends StatefulWidget {
  const AdminPageView({Key? key}) : super(key: key);

  @override
  _AdminPageViewState createState() => _AdminPageViewState();
}

class _AdminPageViewState extends State<AdminPageView> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      KaijuForm(),
      KaijuFormImage(),
      KaijuFormHabs(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        automaticallyImplyLeading: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.pageview), label: 'Formulario'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Imagen'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Habilidades'),
        ],
      ),
    );
  }
}