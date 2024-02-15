import 'package:Abugida/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  final ThemeModel theme;
  ContactScreen(this.theme);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backColor,
      appBar: AppBar(
        backgroundColor: theme.backColor,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          'Contact',
          style: TextStyle(
            color: theme.accentColor,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Telegram',
                  style: TextStyle(
                    color: theme.textColor,
                    fontFamily: 'Maven_Pro',
                    fontSize: 20,
                  ),
                ),
                Divider(
                  color: theme.bodyColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.telegram,
                      size: 45,
                      color: theme.textColor,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url = 'https://te.me/@Gatomii';
                        await launch(url);
                      },
                      child: Text(
                        '@Gatomii',
                        style: TextStyle(
                          color: theme.textColor,
                          fontFamily: 'Maven_Pro',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Gmail',
                  style: TextStyle(
                    color: theme.textColor,
                    fontFamily: 'Maven_Pro',
                    fontSize: 20,
                  ),
                ),
                Divider(
                  color: theme.bodyColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 45,
                      color: theme.textColor,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url = 'https://gmail.com';
                        await launch(url);
                      },
                      child: Text(
                        'gatomi444@gmail.com',
                        style: TextStyle(
                          color: theme.textColor,
                          fontFamily: 'Maven_Pro',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
