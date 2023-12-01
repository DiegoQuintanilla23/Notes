import 'package:app_notes/config.dart';
import 'package:app_notes/home.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;

class NavBar extends StatelessWidget {
  final String usuario;
  final String correo;
  const NavBar({required this.usuario, required this.correo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bkgrndsq.png'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(usuario),
            accountEmail: Text(correo),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child:
                    Image.asset('assets/button.png', color: Colors.transparent),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.fact_check),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Config()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Salir'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Config()));
            },
          ),
        ],
      ),
    );
  }
}
