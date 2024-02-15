class WordStatus {
  String word;
  String meaning;
  String pos;
  List definition;
  String sentence;
  List synonym;
  List antonym;
  WordStatus({
    this.word,
    this.meaning,
    this.pos,
    this.definition,
    this.sentence,
    this.synonym,
    this.antonym,
  });
}

class WordState {
  String word;
  String meaning;
  bool isFav;
  WordState(this.word, this.meaning, this.isFav);
}
