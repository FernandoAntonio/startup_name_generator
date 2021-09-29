import 'package:english_words/english_words.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: GradientAppBar(
        gradient: LinearGradient(
          colors: [
            Colors.green[800],
            Colors.green[700],
            Colors.green[600],
          ],
        ),
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: LiquidPullToRefresh(
        child: _buildSuggestions(),
        onRefresh: _buildOnRefresh,
        showChildOpacityTransition: true,
        color: Colors.green[800],
        springAnimationDurationInMilliseconds: 500,
      ),
    );
  }

  Future<Null> _buildOnRefresh() async {
    setState(() {
      _suggestions.clear();
      _suggestions.addAll(generateWordPairs().take(20));
    });
    return null;
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, i) {
          final index = i;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);
    return Card(
      elevation: 3,
      child: ListTile(
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(wordPair);
            } else {
              _saved.add(wordPair);
            }
          });
        },
        title: Text(
          wordPair.asPascalCase,
          style: _biggerFont,
        ),
        leading: Container(
          width: 20,
          height: 20,
          alignment: Alignment.centerLeft,
          child: FlareActor("assets/plus_ok.flr",
              animation: alreadySaved ? 'PlusToOk' : 'OkToPlus',
              shouldClip: false,
              color: alreadySaved ? Colors.green[900] : Colors.grey),
        ),
        trailing: Container(
            width: 20,
            height: 20,
            alignment: Alignment.centerRight,
            child: FlareActor("assets/heart.flr",
                animation: alreadySaved ? 'Favorite' : 'Unfavorite', shouldClip: false)),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair wordPair) {
        return Dismissible(
          key: Key(wordPair.toString()),
          background: Container(
            color: Colors.white,
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            alignment: Alignment(-0.9, 0),
          ),
          secondaryBackground: Container(
            color: Colors.white,
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            alignment: Alignment(0.9, 0),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd ||
                direction == DismissDirection.endToStart) {
              setState(() {
                _saved.remove(wordPair);
                Flushbar(
                  title: "Name Dismissed",
                  message: "\"${wordPair.asPascalCase}\"",
                  icon: Icon(
                    Icons.remove_circle,
                    size: 25.0,
                    color: Colors.red,
                  ),
                  duration: Duration(seconds: 2),
                  leftBarIndicatorColor: Colors.red,
                  backgroundColor: Colors.grey[900],
                )..show(context);
              });
            }
          },
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(
                wordPair.asPascalCase,
                style: _biggerFont,
              ),
            ),
          ),
        );
      });

      void _deleteAllSaved() async {
        Flushbar(
          message: "All Saved Suggestions Deleted.",
          icon: Icon(
            Icons.remove_circle,
            size: 25.0,
            color: Colors.red,
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.red,
          backgroundColor: Colors.grey[900],
        )..show(context);

        await Future.delayed(
          Duration(seconds: 3),
        );
        _saved.clear();
        Navigator.pop(context);
      }

      return Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(
            colors: [
              Colors.green[800],
              Colors.green[700],
              Colors.green[600],
            ],
          ),
          title: Text('Saved Suggestions'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: _deleteAllSaved,
            )
          ],
        ),
        body: ListView(children: tiles.toList()),
      );
    }));
  }
}
