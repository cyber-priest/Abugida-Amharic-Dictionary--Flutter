import 'dart:convert';
import 'package:Abugida/models/data_model.dart';
import 'package:Abugida/utils/db_helper.dart';
import 'package:flutter/services.dart';

class WordDb {
  static final _wordObject = WordDb._singltonInstance();
  WordDb._singltonInstance();
  factory WordDb() {
    return _wordObject;
  }
  Future opendData() async {
    String data =
        await rootBundle.loadString('assets/json/word_definition.json');
    Map finalData = jsonDecode(data);
    return finalData;
  }
}

class SearchDb {
  static final _searchObject = SearchDb._singltonInstance();
  DbHelper dbHelper = DbHelper();
  SearchDb._singltonInstance();
  factory SearchDb() {
    return _searchObject;
  }
  Future searchData(String word) async {
    List<WordState> newDict = List();
    int index = 0;
    String data = await rootBundle.loadString('assets/json/word_meaning.json');
    Map finalData = jsonDecode(data);
    bool isFav;
    await dbHelper.openDb();
    List favData = await dbHelper.getFavWord();
    finalData.forEach((key, value) {
      isFav = favData.contains(key);
      if (word != null) {
        String uppWord = word.toUpperCase();
        if (uppWord.matchAsPrefix(key.toUpperCase()) != null) {
          newDict.insert(index, WordState(key, value, isFav));
          index++;
        }
      } else {
        newDict.insert(index, WordState(key, value, isFav));
        index++;
      }
    });
    return newDict;
  }
}
