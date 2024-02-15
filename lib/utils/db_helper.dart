import 'dart:convert';
import 'dart:math';

import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }
  Database db;
  int version = 1;
  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'abugida.db'),
          onCreate: (database, version) {
        database.execute('CREATE TABLE history(word TEXT, meaning TEXT)');
        database.execute('CREATE TABLE favorite(word TEXT, meaning TEXT)');
        database.execute('CREATE TABLE word_day(word TEXT, meaning TEXT)');
        database.execute('CREATE TABLE theme(theme TEXT)');
        database.insert('theme', {'theme': 'light'});
      }, version: version);
    }
    return db;
  }

  createTable() async {
    await db.execute('CREATE TABLE history(word TEXT, meaning TEXT)');
    await db.execute('CREATE TABLE favorite(word TEXT, meaning TEXT)');
    await db.execute('CREATE TABLE word_day(word TEXT, meaning TEXT)');
    await db.execute('CREATE TABLE theme(theme TEXT)');
    await db.insert('theme', {'theme': 'light'});
  }

  deleteTable() async {
    await db.execute('DROP TABLE history');
    await db.execute('DROP TABLE favorite');
    await db.execute('DROP TABLE word_day');
    await db.execute('DROP TABLE theme');
  }

  Future<int> insertHistory(String word, String meaning) async {
    List histData = await getHistory();
    for (var data in histData) {
      if (data.word == word) {
        await deleteHistory(word, meaning);
        
      }
    }
    int id = await db.insert('history', {'word': word, 'meaning': meaning},
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> insertFavorite(String word, String meaning) async {
    int id = await db.insert('favorite', {'word': word, 'meaning': meaning});
    return id;
  }

  deleteHistory(String word, String meaning) async {
    await db.delete('history', where: 'word=?', whereArgs: [word]);
  }

  deleteAllHistory() async {
    await db.delete('history', where: null);
  }

  deleteFavorite(String word, String meaning) async {
    await db.delete('favorite', where: 'word=?', whereArgs: [word]);
  }

  Future<List> getHistory() async {
    final List rawHistList = await db.query('history');
    List favdata = await getFavWord();
    bool isFav = false;
    List<WordState> histList = List();
    for (var each in rawHistList) {
      isFav = favdata.contains(each['word']);
      histList.add(WordState(each['word'], each['meaning'], isFav));
    }
    return histList;
  }

  Future<List> getFavorite() async {
    final List rawFavList = await db.query('favorite');
    List<WordState> favList = List();
    for (var each in rawFavList) {
      favList.add(WordState(each['word'], each['meaning'], true));
    }
    return favList;
  }

  Future<bool> isFav(String word) async{
    await openDb();
    final List rawFavList = await db.query('favorite');
    bool isfav = false;
    for (var each in rawFavList) {
      if (word == each['word']) {
        isfav = true;
      }
    }
    return isfav;
  }

  Future<List> getFavWord() async {
    final List favList = await db.query('favorite');
    List word = List();
    for (var favWord in favList) {
      word.add(favWord['word']);
    }
    return word;
  }

  //? theme handler

  setTheme(String theme) async {
    await openDb();
    await db.delete('theme', where: null);
    await db.insert('theme', {'theme': theme});
  }

  Future<ThemeModel> assignTheme() async {
    await openDb();
    List data = await db.query('theme');
    String theme = data[0]['theme'];
    if (theme == 'light') {
      return ThemeModel(
        'light',
        Colors.white,
        Colors.grey.shade200,
        Colors.blueGrey,
        Color.fromRGBO(65, 65, 65, 0.8),
        Color.fromRGBO(88, 88, 88, 0.8),
      );
    } else {
      return ThemeModel(
        'dark',
        Color.fromRGBO(45, 45, 45, 1),
        Color.fromRGBO(55, 55, 55, 1),
        Colors.blueGrey,
        Color.fromRGBO(176, 176, 176, 0.8),
        Color.fromRGBO(150, 150, 150, 0.6),
      );
    }
  }

  Future<String> getTheme() async {
    await openDb();
    List theme = await db.query('theme');
    return theme[0]['theme'];
  }

  //! word of z day loader
  Future<List> getRawWord() async {
    await openDb();
    List word = await db.query('word_day');
    return word;
  }
  Future<String> getWord() async{
    await openDb();
    List rawWord = await getRawWord();
    return rawWord[0]['word'];
  }

  Future<String> assignWord() async {
    Random random = Random();
    String data = await rootBundle.loadString('assets/json/word_meaning.json');
    Map finalData = jsonDecode(data);
    List words = List();
    finalData.forEach((key, value) {
      words.add(key);
    });
    String word = words[random.nextInt(words.length)];
    return word;
  }

  setWord() async {
    await openDb();
    var now = DateTime.now();
    var formate = DateFormat('yyyy-MM-dd');
    var currentTime = formate.format(now);
    List oldWord = await getRawWord();
    if (oldWord.isEmpty) {
      String word = await assignWord();
      await db.insert('word_day', {'word': word, 'meaning':currentTime});
    } else {
      if (oldWord[0].containsValue(currentTime) == false) {
        await db.delete('word_day', where: null);
        String word = await assignWord();
        await db.insert('word_day', {'word': word, 'meaning':currentTime});
      }
    }
  }
}
