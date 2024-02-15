import 'dart:async';
import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/models/theme_model.dart';
import 'package:Abugida/screens/favorite_screen.dart';
import 'package:Abugida/screens/history_screen.dart';
import 'package:Abugida/screens/word_day_screen.dart';
import 'package:Abugida/utils/db_helper.dart';
import 'package:Abugida/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/home_screen.dart';
import 'utils/word_db.dart';

void main() => runApp(Abugida());

class Abugida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abugida Dictionary',
      color: Colors.grey.shade100,
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Color.fromRGBO(247, 206, 146, 1),
        primaryColorLight: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AbuScreen extends StatefulWidget {
  @override
  _AbuScreenState createState() => _AbuScreenState();
}

class _AbuScreenState extends State<AbuScreen> {
  DbHelper dbHelper = DbHelper();
  String word;
  static ThemeModel theme = ThemeModel('light', Colors.white,
      Colors.grey.shade200, Colors.blueGrey, Colors.black, Colors.grey);

  void initState() {
    super.initState();
    setTheme();
    setWord();
  }

  setTheme() async {
    await dbHelper.openDb();
    theme = await dbHelper.assignTheme();
    setState(() {
      theme = theme;
      screens = [
        HomeScreen(null, theme),
        HistoryScreen(theme),
        FavoriteScreen(theme),
        WordDayScreen(theme)
      ];
      drawer = CustomDrawer(theme);
      screen = HomeScreen(null, theme);
    });
  }

  setWord() async {
    await dbHelper.openDb();
    await dbHelper.setWord();
  }

  loadSearchData(String word) async {
    List<WordState> searchList;
    SearchDb searchDb = SearchDb();
    searchList = await searchDb.searchData(word);
    return searchList;
  }

  insertHistory(String word, String meaning) async {
    await dbHelper.openDb();
    int id = await dbHelper.insertHistory(word, meaning);
    print(id);
  }

  int currentScreen = 0;
  int history = 0;
  List<Widget> screens = [
    HomeScreen(null, theme),
    HistoryScreen(theme),
    FavoriteScreen(theme),
    WordDayScreen(theme)
  ];
  Widget screen = HomeScreen(null, theme);
  Widget drawer = CustomDrawer(theme);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.bodyColor,
        drawer: drawer,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: theme.backColor,
                iconTheme: IconThemeData(color: theme.accentColor),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                ),
                bottom: PreferredSize(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.backColor,
                        ),
                        child: TextField(
                          onChanged: (text) {
                            word = text;
                            setState(() {
                              word = word;
                              screen = HomeScreen(word, theme);
                              currentScreen = 0;
                            });
                            print(word);
                          },
                          style: TextStyle(
                              color: theme.subTextColor, fontSize: 18),
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.search,
                                color: theme.subTextColor,
                              ),
                              hintText: 'Search....',
                              fillColor: Theme.of(context).primaryColor,
                              hintStyle: TextStyle(color: theme.subTextColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ),
                    preferredSize: Size(8, 87)),
                title: Text(
                  'Abugida Dictionary',
                  style: TextStyle(
                      color: theme.accentColor,
                      fontFamily: 'Comfortaa',
                      fontWeight: FontWeight.w600),
                ),
                actions: [
                  IconButton(
                    icon: (theme.type == 'light')
                        ? Icon(
                            Icons.brightness_2,
                            size: 20,
                          )
                        : Icon(
                            FontAwesomeIcons.solidLightbulb,
                            color: Colors.white,
                            size: 20,
                          ),
                    onPressed: () async {
                      (theme.type == 'light')
                          ? await dbHelper.setTheme('dark')
                          : await dbHelper.setTheme('light');
                      theme = await dbHelper.assignTheme();
                      screens = [
                        HomeScreen(null, theme),
                        HistoryScreen(theme),
                        FavoriteScreen(theme),
                        WordDayScreen(theme)
                      ];
                      setState(() {
                        theme = theme;
                        screens = screens;
                        screen = screens[currentScreen];
                        drawer = CustomDrawer(theme);
                      });
                    },
                  )
                ],
                floating: true,
                snap: true,
                pinned: true,
                expandedHeight: 150.0,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: screen,
        ),
        floatingActionButton: (currentScreen == 1)
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    dbHelper.deleteAllHistory();
                    screen = HistoryScreen(theme);
                  });
                })
            : null,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentScreen,
            onTap: (index) {
              setState(() {
                currentScreen = index;
                screen = screens[index];
              });
            },
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.blueGrey,
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                backgroundColor: theme.backColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('History'),
                backgroundColor: theme.backColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('Favorites'),
                backgroundColor: theme.backColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.book,
                  size: 20,
                ),
                title: Text('Word of the day'),
                backgroundColor: theme.backColor,
              ),
            ]),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AbuScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/Abu_med.png'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Abugida Dictionary',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Comfortaa',
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'FAST, MODERN, EASY TRANSLATION SYSTEM',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Maven_Pro',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
