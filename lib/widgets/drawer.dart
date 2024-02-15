import 'package:Abugida/models/theme_model.dart';
import 'package:Abugida/screens/about.dart';
import 'package:Abugida/screens/contact.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final ThemeModel theme;
  CustomDrawer(this.theme);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            color: theme.backColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepOrangeAccent,
              radius: 30,
              backgroundImage: AssetImage('assets/images/Abu_med.png'),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Abugida Dictionary',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 17,
                    fontFamily: 'Comfortaa')),
            Divider(
              color: theme.bodyColor,
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactScreen(theme)));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 45),
              leading: Icon(Icons.contact_phone, color: theme.subTextColor),
              title: Text(
                'Contact',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 17,
                  color: theme.textColor,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutScreen(theme)));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 45),
              leading: Icon(
                Icons.info,
                color: theme.subTextColor,
              ),
              title: Text(
                'About',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 17,
                  color: theme.textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
