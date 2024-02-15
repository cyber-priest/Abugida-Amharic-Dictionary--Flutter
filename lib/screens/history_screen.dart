import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/models/theme_model.dart';
import 'package:Abugida/screens/def_screen.dart';
import 'package:Abugida/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryScreen extends StatefulWidget {
  final ThemeModel theme;
  HistoryScreen(this.theme);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String word;
  DbHelper dbHelper = DbHelper();
  FlutterTts flutterTts = FlutterTts();

  loadHistory() async {
    await dbHelper.openDb();
    List<WordState> data = await dbHelper.getHistory();
    List newData = data.reversed.toList();
    return newData;
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
            future: loadHistory(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<WordState> newDict = snapshot.data;
              if (newDict != null) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    WordState wordState = newDict[index];
                    return Dismissible(
                      key: Key(wordState.word),
                      onDismissed: (direction) {
                        dbHelper.deleteHistory(
                            wordState.word, wordState.meaning);
                      },
                      child: FlatButton(
                        onPressed: () {
                          insertHistory(wordState.word, wordState.meaning);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DefScreen(
                                      wordState.word,
                                      wordState.meaning,
                                      widget.theme)));
                        },
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          dense: true,
                          leading: IconButton(
                            onPressed: () async{
                              await speak(wordState.word);
                            },
                            icon: Icon(FontAwesomeIcons.volumeUp,
                                size: 20, color: widget.theme.subTextColor),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                dbHelper.deleteHistory(
                                    wordState.word, wordState.meaning);
                              });
                            },
                            icon: Icon(Icons.delete,
                                size: 25, color: widget.theme.subTextColor),
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
