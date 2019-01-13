import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // A randomly generated word.
  final wordPair = WordPair.random();

  /// Generates random words and return it.
  /// @return Random string.
  String getRandomWord() => WordPair.random().asString;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWord(),
    );
  }
}

class RandomWord extends StatefulWidget {
  @override
  RandomWordState createState() {
    return new RandomWordState();
  }
}

class RandomWordState extends State<RandomWord> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont2 = TextStyle(fontSize: 11.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StartupName Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont2,
            ),
          );
        });

        List<Widget> devided = tiles.toList();
        List<Widget> devided2 = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return new Scaffold(
            appBar: new AppBar(
              title: const Text('Save Suggesions'),
            ),
            body: new ListView(children: devided));
      }),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(itemBuilder: (context, i) {
      if (i.isOdd) return Divider();
      final index = i ~/ 2;
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asCamelCase,
        style: _biggerFont2,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
