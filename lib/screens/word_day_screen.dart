import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/models/theme_model.dart';
import 'package:Abugida/utils/db_helper.dart';
import 'package:Abugida/utils/word_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WordDayScreen extends StatefulWidget {
  final ThemeModel theme;
  WordDayScreen(this.theme);
  @override
  _WordDayScreenState createState() => _WordDayScreenState();
}

class _WordDayScreenState extends State<WordDayScreen> {
  WordStatus wordStatus;
  DbHelper dbHelper = DbHelper();
  WordDb wordData = WordDb();
  FlutterTts flutterTts = FlutterTts();

  Future speak(String word) async {
    var result = await flutterTts.speak(word);
  }

  loadData() async {
    Map wordsMap = await wordData.opendData();
    String english = await dbHelper.getWord();
    await dbHelper.openDb();
    bool isFav = await dbHelper.isFav(english);
    List definition = List();
    int index = 0;
    wordsMap[english]['definition'].forEach((key, value) {
      definition.insert(index, value);
    });
    wordStatus = WordStatus(
        word: english,
        meaning: wordsMap[english]['meaning'],
        pos: wordsMap[english]['pos'],
        definition: definition,
        sentence: wordsMap[english]['sentence'],
        synonym: wordsMap[english]['synonym'],
        antonym: wordsMap[english]['antonym']);
    return [wordStatus, isFav];
  }

  Widget _buildDefinition(List def) {
    List<Widget> defs = [];
    int index = 0;
    int counter = 1;
    for (var eachdef in def) {
      defs.insert(
          index,
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              eachdef[1],
              style: TextStyle(
                  fontWeight: FontWeight.w300, color: widget.theme.textColor),
            ),
            leading: Text(
              '$counter. ${eachdef[0]}',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: widget.theme.accentColor),
            ),
            subtitle: (eachdef[3].isEmpty)
                ? null
                : Text(
                    'Ex : ${eachdef[3][0]}',
                    style: TextStyle(
                      color: widget.theme.subTextColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
          ));
      counter++;
      index++;
    }
    return Column(
      children: defs,
    );
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
            future: loadData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List data = snapshot.data;
              if (data != null) {
                WordStatus wordStatus = data[0];
                bool isFav = data[1];
                return ListView(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15),
                        // margin: EdgeInsets.symmetric(
                        //   horizontal: 10,
                        // ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: widget.theme.backColor,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.volumeUp,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                                    onPressed: () async{
                                      await speak(wordStatus.word);
                                    }),
                                Text(
                                  wordStatus.word,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 23,
                                    fontFamily: 'Maven_Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                IconButton(
                                  icon: (isFav == false)
                                      ? Icon(
                                          Icons.favorite_border,
                                          color: Colors.blueGrey,
                                        )
                                      : Icon(
                                          Icons.favorite,
                                          color: Colors.blueGrey,
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      if (isFav == false) {
                                        isFav = true;
                                        dbHelper.insertFavorite(wordStatus.word,
                                            wordStatus.meaning);
                                      } else {
                                        isFav = false;
                                        dbHelper.deleteFavorite(wordStatus.word,
                                            wordStatus.meaning);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            Text(
                              wordStatus.pos,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              wordStatus.meaning,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        // height: 400,
                        decoration: BoxDecoration(
                          color: widget.theme.backColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Definition:',
                              style: TextStyle(
                                color: widget.theme.textColor.withOpacity(0.6),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            _buildDefinition(wordStatus.definition),
                            Text(
                              'Example:',
                              style: TextStyle(
                                color: widget.theme.textColor.withOpacity(0.6),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            Container(
                              child: Text(
                                wordStatus.sentence,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: widget.theme.subTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Synonym:',
                              style: TextStyle(
                                color: widget.theme.textColor.withOpacity(0.6),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            Container(
                              child: Text(
                                wordStatus.synonym.join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: widget.theme.subTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Antonym:',
                              style: TextStyle(
                                color: widget.theme.textColor.withOpacity(0.6),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(),
                            Container(
                              child: Text(
                                wordStatus.antonym.join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: widget.theme.subTextColor,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
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
