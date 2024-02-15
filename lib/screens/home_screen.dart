import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/models/theme_model.dart';
import 'package:Abugida/screens/def_screen.dart';
import 'package:Abugida/utils/db_helper.dart';
import 'package:Abugida/utils/word_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String word;
  final ThemeModel theme;
  HomeScreen(this.word, this.theme);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper dbHelper = DbHelper();
  FlutterTts flutterTts = FlutterTts();
  var currentDate = DateTime.august;
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

  Future speak(String word) async {
    var result = await flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: widget.theme.backColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              )),
          child: FutureBuilder(
            future: loadSearchData(widget.word),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<WordState> newDict = snapshot.data;
              if (newDict != null) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    WordState wordState = newDict[index];
                    return FlatButton(
                      onPressed: () {
                        print(currentDate);
                        insertHistory(wordState.word, wordState.meaning);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DefScreen(wordState.word,
                                    wordState.meaning, widget.theme)));
                      },
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        dense: true,
                        leading: IconButton(
                          onPressed: () async {
                            await speak(wordState.word);
                          },
                          icon: Icon(
                            FontAwesomeIcons.volumeUp,
                            size: 20,
                            color: widget.theme.subTextColor,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              if (wordState.isFav == false) {
                                wordState.isFav = true;
                                dbHelper.insertFavorite(
                                    wordState.word, wordState.meaning);
                              } else {
                                wordState.isFav = false;
                                dbHelper.deleteFavorite(
                                    wordState.word, wordState.meaning);
                              }
                            });
                          },
                          icon: (wordState.isFav == false)
                              ? Icon(
                                  Icons.favorite_border,
                                  size: 25,
                                  color: widget.theme.subTextColor,
                                )
                              : Icon(
                                  Icons.favorite,
                                  size: 25,
                                  color: widget.theme.subTextColor,
                                ),
                        ),
                        title: Text(
                          wordState.word,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Maven_Pro',
                              fontSize: 15,
                              color: widget.theme.textColor.withOpacity(1)),
                        ),
                        subtitle: Text(
                          wordState.meaning,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: widget.theme.subTextColor),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator()),
                );
              }
            },
          )),
    );
  }
}
