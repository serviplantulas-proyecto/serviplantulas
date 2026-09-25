import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/login.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/bandera-colombia.jpg"),
            ),
            accountName: Text("David"),
            accountEmail: Text("davidffajardoq2007@gmail.com"),
            decoration: BoxDecoration(color: Colors.lightBlue),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Inicio"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("colombia"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text("cartagena"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text("Pereira"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("medellin"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("bucaramanga"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.access_alarm),
            title: Text("neiva"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }
}
