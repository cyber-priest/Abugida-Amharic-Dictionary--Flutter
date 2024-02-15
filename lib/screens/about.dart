import 'package:Abugida/models/theme_model.dart';
import 'package:flutter/material.dart';


class AboutScreen extends StatelessWidget {
  final ThemeModel theme;
  AboutScreen(this.theme);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backColor,
      appBar: AppBar(
        backgroundColor: theme.backColor,
        iconTheme: IconThemeData(color: Colors.blueGrey),
        title: Text(
          'About',
          style: TextStyle(
            color: theme.accentColor,
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          buildAboutAbu(),
          SizedBox(
            height: 30,
          ),
          buildAboutDev(),
        ],
      ),
    );
  }

  Padding buildAboutDev() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Developer',
                style: TextStyle(
                    color: theme.textColor,
                    // fontWeight: FontWeight.w300,
                    fontSize: 18,
                    fontFamily: 'Maven_Pro'),
              ),
              Divider(
                color: theme.bodyColor,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.backColor,
                    radius: 40,
                    backgroundImage: AssetImage(
                      'assets/images/My_Pic.png',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Mikael Alehegn',
                    style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        fontFamily: 'Maven_Pro'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  child: Text(
                'I am a cross platform mobile and desktop app developer. Also interested in web backend development.',
                style: TextStyle(
                  color: theme.subTextColor,
                  fontFamily: 'Maven_Pro',
                  fontSize: 16,
                ),
              ))
            ],
          ),
        );
  }

  Column buildAboutAbu() {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: theme.backColor,
          radius: 70,
          backgroundImage: AssetImage('assets/images/Abu_med.png'),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Abugida Amharic-English Dictionary',
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Maven_Pro',
          ),
        ),
        Text(
          'Version A1.0.0',
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Maven_Pro',
          ),
        ),
        Text(
          'Copyright 2020 Abugida',
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Maven_Pro',
          ),
        ),
      ],
    );
  }
}
